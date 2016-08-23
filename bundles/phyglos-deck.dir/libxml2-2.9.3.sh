#!/bin/bash

build_compile()
{
    tar xf $BUILD_SOURCES/xmlts20130923.tar.gz

    ./configure          \
	--prefix=/usr    \
        --disable-static \
        --with-history 

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
