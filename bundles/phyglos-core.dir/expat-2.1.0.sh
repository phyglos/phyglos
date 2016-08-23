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
    make DESTDIR=$BUILD_PACK install

    install -v -dm755 $BUILD_PACK/usr/share/doc/expat-2.1.0
    install -v -m644 doc/*.{html,png,css} $BUILD_PACK/usr/share/doc/expat-2.1.0
}
