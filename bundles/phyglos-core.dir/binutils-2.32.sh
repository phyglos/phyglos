#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    ../configure             \
        --prefix=/usr        \
	--enable-gold        \
	--enable-ld=default  \
	--enable-plugins     \
	--enable-shared      \
	--enable-64-bit-bfd  \
	--disable-werror     \
	--with-system-zlib

    make tooldir=/usr
}

build_test_level=1
build_test()
{
    make -k check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	 tooldir=/usr        \
	 install
}
