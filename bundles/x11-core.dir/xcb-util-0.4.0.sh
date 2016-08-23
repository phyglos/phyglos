#!/bin/bash


build_compile()
{
    ./configure $PHY_XORG_CONFIG

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
