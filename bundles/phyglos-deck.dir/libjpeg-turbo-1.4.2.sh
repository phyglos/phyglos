#!/bin/bash

build_compile()
{
    sed -e '/^docdir/ s:$:/libjpeg-turbo-1.4.2:' \
	-i Makefile.in

    ./configure                 \
	--prefix=/usr           \
        --mandir=/usr/share/man \
        --with-jpeg8            \
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
     make DESTDIR=$BUILD_PACK install
}
