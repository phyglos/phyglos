#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr

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

    bandit_mkdir $BUILD_PACK/usr/share/doc/gawk-4.1.3
    cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} $BUILD_PACK/usr/share/doc/gawk-4.1.3
}
