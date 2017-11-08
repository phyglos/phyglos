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

    bandit_mkdir $BUILD_PACK/usr/share/doc/libgcrypt-1.8.0
    cp -v README doc/{README.apichanges,fips*,libgcrypt*} \
       $BUILD_PACK/usr/share/doc/libgcrypt-1.8.0
}

