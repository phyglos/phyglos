#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
	--libexecdir=/usr/lib/vte

    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
