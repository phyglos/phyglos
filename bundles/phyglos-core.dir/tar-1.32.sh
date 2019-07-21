#!/bin/bash

build_compile()
{
    FORCE_UNSAFE_CONFIGURE=1  \
    ./configure               \
	--prefix=/usr         \
	--bindir=/bin

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
    make DESTDIR=$BUILD_PACK -C doc install-html docdir=/usr/share/doc/tar-1.32
}
