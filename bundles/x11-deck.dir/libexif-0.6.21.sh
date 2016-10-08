#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--with-doc-dir=/usr/share/doc/libexif-0.6.21 \
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
