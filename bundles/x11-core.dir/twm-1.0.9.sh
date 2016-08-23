#!/bin/bash


build_compile()
{
    sed -e '/^rcdir =/s|^\(rcdir = \).*|\1/etc/X11/app-defaults|' \
	-i src/Makefile.in

    ./configure $PHY_XORG_CONFIG

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
