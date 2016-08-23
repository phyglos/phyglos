#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
	--docdir=/usr/share/doc/gettext-0.19.7

    make
}

build_test_level=3
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
