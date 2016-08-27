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
}

