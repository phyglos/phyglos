#!/bin/bash

build_compile()
{
    ./configure $PHY_XORG_CONFIG \
		--with-udev-rules-dir=/lib/udev/rules.d \
		--without-hal-callouts-dir \
		--without-hal-fdi-dir

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

