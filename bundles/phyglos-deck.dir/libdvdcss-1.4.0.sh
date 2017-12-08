#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
        --docdir=/usr/share/doc/libdvdcss-1.4.0

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

