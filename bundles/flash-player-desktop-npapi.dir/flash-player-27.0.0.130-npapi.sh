#!/bin/bash

build_pack()
{
    # Copy in build pack
    bandit_mkdir $BUILD_PACK
    cp -vR * $BUILD_PACK
       
    # Move files to /usr/share/flashplayer
    bandit_mkdir $BUILD_PACK/usr/share/flashplayer
    mv -v $BUILD_PACK/readme.txt  $BUILD_PACK/usr/share/flashplayer
    mv -v $BUILD_PACK/license.pdf $BUILD_PACK/usr/share/flashplayer
    mv -v $BUILD_PACK/LGPL        $BUILD_PACK/usr/share/flashplayer

    # Place libflashplayer in mozilla plugins directory
    bandit_mkdir $BUILD_PACK/usr/lib/mozilla/plugins
    mv -v $BUILD_PACK/libflashplayer.so $BUILD_PACK/usr/lib/mozilla/plugins
}

