#!/bin/bash

build_compile()
{
    sed -e '/^libdocdir =/ s/$(book_name)/glibmm-2.46.3/' \
	-i docs/Makefile.in

    ./configure --prefix=/usr 

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
