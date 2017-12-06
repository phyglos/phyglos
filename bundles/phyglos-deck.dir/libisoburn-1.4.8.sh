#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
	--enable-pkg-check-modules

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
