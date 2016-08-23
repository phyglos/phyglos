#!/bin/bash

build_compile()
{
    ./configure            \
	--prefix=/usr      \
	--libdir=/usr/lib  \
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

    chmod   -v   755 $BUILD_PACK/usr/lib/lib{hogweed,nettle}.so

    install -v -m755 -d          $BUILD_PACK/usr/share/doc/nettle-3.2
    install -v -m644 nettle.html $BUILD_PACK/usr/share/doc/nettle-3.2
}
