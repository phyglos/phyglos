#!/bin/bash

build_compile()
{
    sed -i '/stdlib/a #include <limits.h>' transport.hxx
    
    make all rpl8 btcflash
}

build_pack()
{
    make prefix=$BUILD_PACK/usr install

    bandit_mkdir $BUILD_PACK/usr/share/doc/dvd+rw-tools-7.1
    cp -v index.html $BUILD_PACK/usr/share/doc/dvd+rw-tools-7.1
}

