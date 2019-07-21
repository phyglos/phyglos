#!/bin/bash

build_compile()
{
    ./configure         \
	--prefix=/usr   \
	--disable-static

    make 
}

build_test_level=3
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
         docdir=/usr/share/doc/check-0.12.0 \
         install
}
