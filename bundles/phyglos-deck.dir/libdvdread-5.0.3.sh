#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
        --docdir=/usr/share/doc/libdvdread-5.0.3

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

