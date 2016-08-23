#!/bin/bash


build_compile()
{
    ./configure $PHY_XORG_CONFIG  --with-appdefaultdir=/etc/X11/app-defaults
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
