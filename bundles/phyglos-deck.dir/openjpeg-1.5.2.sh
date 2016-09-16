#!/bin/bash

build_compile()
{
    autoreconf -f -i
    
    ./configure          \
	--prefix=/usr    \
	--disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
