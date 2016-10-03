#!/bin/bash

build_compile()
{   
    ./configure \
	--prefix=$XORG_PREFIX \
        --disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

