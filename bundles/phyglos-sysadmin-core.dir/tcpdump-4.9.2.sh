#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr 
    
    make
}

build_test_level=0
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    # Remove duplicated binary
    rm $BUILD_PACK/usr/sbin/tcpdump.*
}

