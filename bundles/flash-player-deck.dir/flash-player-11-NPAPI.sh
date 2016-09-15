#!/bin/bash

build_pack()
{
    # Remove text files
    rm -rvf LGPL/
    rm -v readme.txt
    
    # Remove KDE libs and shares
    rm -rvf usr/lib*
    rm -rvf usr/share/kde*

    # Copy in build pack
    bandit_mkdir $BUILD_PACK
    cp -vR * $BUILD_PACK
    
    # Place libflashplayer in mozilla plugins directory
    bandit_mkdir $BUILD_PACK/usr/lib/mozilla/plugins
    mv -v $BUILD_PACK/libflashplayer.so $BUILD_PACK/usr/lib/mozilla/plugins
}

