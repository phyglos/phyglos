#!/bin/bash

build_compile()
{
    sed -i -e '/test-bison/d' tests/Makefile.in

    ./configure \
	--prefix=/usr \
        --docdir=/usr/share/doc/flex-2.6.0

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

    ln -s flex $BUILD_PACK/usr/bin/lex
}
