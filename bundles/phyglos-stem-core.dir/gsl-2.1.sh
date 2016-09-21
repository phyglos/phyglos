#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr         \
        --disable-static

    make
    make html
}

build_test_level=1
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/gsl-2.1
    cp doc/gsl-ref.html/* $BUILD_PACK/usr/share/doc/gsl-2.1
}

