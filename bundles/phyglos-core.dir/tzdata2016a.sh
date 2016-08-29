#!/bin/bash 

build_pack()
{
    local ZONEINFO=$BUILD_PACK/usr/share/zoneinfo

    bandit_mkdir $ZONEINFO/{posix,right}
    for tz in etcetera southamerica northamerica europe africa antarctica  \
	      asia australasia backward pacificnew systemv; do
	zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
	zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
	zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
    done
    cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
    zic -d $BUILD_PACK/usr/share/zoneinfo -p America/New_York
    
    bandit_mkdir $BUILD_PACK/etc
    cp -v $BUILD_PACK/usr/share/zoneinfo/${PHY_TIMEZONE} $BUILD_PACK/etc/localtime
}

