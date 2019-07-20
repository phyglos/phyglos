#!/bin/bash

build_compile()
{
    PREFIX=/usr       \
    CC=gcc            \
    CFLAGS="-std=c99" \
    ./configure.sh -G -O3
    
    make
}

build_test_level=3
build_test()
{
    make test 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
