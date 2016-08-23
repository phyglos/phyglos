#!/bin/bash

build_compile()
{
    gzip -cd $BUILD_SOURCES/libpng-1.6.21-apng.patch.gz | patch -p0

    ./configure          \
	--prefix=/usr    \
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

    bandit_mkdir $BUILD_PACK/usr/share/doc/libpng-1.6.21
    cp -v README libpng-manual.txt $BUILD_PACK/usr/share/doc/libpng-1.6.21
}
