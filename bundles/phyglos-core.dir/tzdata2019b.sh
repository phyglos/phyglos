#!/bin/bash 

build_pack()
{
    local ZONEINFO=$BUILD_PACK/usr/share/zoneinfo

    bandit_mkdir $ZONEINFO/{posix,right}
    for tz in etcetera southamerica northamerica europe africa antarctica  \
	      asia australasia backward pacificnew systemv; do
	zic -L /dev/null   -d $ZONEINFO       ${tz}
	zic -L /dev/null   -d $ZONEINFO/posix ${tz}
	zic -L leapseconds -d $ZONEINFO/right ${tz}
    done
    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $BUILD_PACK/usr/share/zoneinfo -p America/New_York
    
    bandit_mkdir $BUILD_PACK/etc
    cp -v $BUILD_PACK/usr/share/zoneinfo/${PHY_TIMEZONE} $BUILD_PACK/etc/localtime
}

