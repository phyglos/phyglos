#!/bin/bash

build_compile()
{
    ./configure                           \
	--prefix=/usr                     \
	--docdir=/usr/share/doc/mpc-1.0.3 \
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

