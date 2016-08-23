#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
	--enable-tee

    make
}


build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
