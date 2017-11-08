#!/bin/bash

build_compile()
{
    ./configure \
	--prefix=/usr
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/libgpg-error-1.27/
    cp -v README $BUILD_PACK/usr/share/doc/libgpg-error-1.27/README
}

