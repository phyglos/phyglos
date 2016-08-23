#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
        --bindir=/bin \
        --htmldir=/usr/share/doc/sed-4.2.2

    make
    make html
}

build_test_level=3
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    make DESTDIR=$BUILD_PACK -C doc install-html
}
