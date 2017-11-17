#!/bin/bash

build_compile()
{
    ./configure         \
	--prefix=/usr   \
	--enable-shared \
	--disable-cli

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

