#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/fuser   $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/killall $BUILD_PACK/bin
}
