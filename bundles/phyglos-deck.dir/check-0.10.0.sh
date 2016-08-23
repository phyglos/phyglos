#!/bin/bash


build_compile()
{
    ./configure       \
	--prefix=/usr \
	--disable-static

    make 
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install \
	docdir=/usr/share/doc/check-0.10.0 
}

