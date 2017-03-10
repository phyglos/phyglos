#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/binutils-2.26-upstream_fix-2.patch

    mkdir -v build
    cd build

    ../configure          \
	--prefix=/usr     \
	--enable-shared   \
	--disable-werror

    make tooldir=/usr
}

build_test_level=1
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	 tooldir=/usr        \
	 install
}
