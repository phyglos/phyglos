#!/bin/bash

build_compile()
{
    ./configure                \
	--prefix=/usr          \
	--disable-install-rdoc \
	--disable-install-capi \
        --docdir=/usr/share/doc/ruby-2.5.1

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
}

