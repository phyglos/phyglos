#!/bin/bash


build_compile()
{
    ./configure $PHY_XORG_CONFIG

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
