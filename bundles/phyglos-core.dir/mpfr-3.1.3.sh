#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/mpfr-3.1.3-upstream_fixes-2.patch

    ./configure                            \
	--prefix=/usr                      \
	--enable-thread-safe               \
	--docdir=/usr/share/doc/mpfr-3.1.3 \
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
