#!/bin/bash

build_compile()
{
    ./configure                            \
	--prefix=/usr                      \
	--enable-thread-safe               \
	--docdir=/usr/share/doc/mpfr-4.0.2 \
	--disable-static    

    make
    make html
}

build_test_level=1
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    make DESTDIR=$BUILD_PACK install-html
}
