#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr         \
        --disable-static      \
        --with-installbuilddir=/usr/share/apr-1/build
    
    make
}

build_test_level=2
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

