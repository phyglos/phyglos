#!/bin/bash

build_compile()
{
    sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c

    ./configure       \
	--prefix=/usr \
	--bindir=/bin

    make
}

build_test_level=2
build_test_level()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
