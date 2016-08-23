#!/bin/bash

build_compile()
{
    sed -i 's#) ytasm.*#)#' Makefile.in

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
