#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
        --disable-static 

    make
}

build_test_level=2
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 

    find doc -name "Makefile*" -delete            
    rm -rf -v doc/{gdoc,idn.1,stamp-vti,man,texi} 

    bandit_mkdir $BUILD_PACK/usr/share/doc/libidn-1.32     
    cp -vr doc/* $BUILD_PACK/usr/share/doc/libidn-1.32
}
