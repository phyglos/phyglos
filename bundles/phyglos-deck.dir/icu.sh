#!/bin/bash


build_compile()
{
    cd source

    ./configure --prefix=/usr

    make
}

build_test_level=4
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
