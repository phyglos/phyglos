#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -s libdnet.1.0.1 $BUILD_PACK/usr/lib/libdnet.so
}

