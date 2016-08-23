#!/bin/bash


build_compile()
{
    sed -e '/$serverargs $vtarg/ s/serverargs/: #&/' \
	-i startx.cpp

    ./configure $PHY_XORG_CONFIG \
	--with-xinitdir=/etc/X11/app-defaults

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

