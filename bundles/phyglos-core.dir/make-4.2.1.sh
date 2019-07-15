#!/bin/bash

build_compile()
{
    sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c
    
    ./configure --prefix=/usr

    make
}

build_test_level=1
build_test()
{
    make check
}


build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
