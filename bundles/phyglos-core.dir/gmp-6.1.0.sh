#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
	--enable-cxx      \
	--disable-static  \
	--docdir=/usr/share/doc/gmp-6.1.0

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
