#!/bin/bash

build_compile()
{
    sed -e 's|xfce4/panel-plugins|xfce4/panel/plugins|' \
	-i panel-plugin/{Makefile.in,xkb-plugin.desktop.in.in}

    ./configure            \
	--prefix=/usr      \
	--libexec=/usr/lib \
	--disable-debug

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
