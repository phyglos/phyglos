#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--docdir=/usr/share/doc/bison-3.0.4

    make
}

build_test_level=2
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

