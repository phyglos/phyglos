#!/bin/bash

build_compile()
{
    ./configure \
        --prefix=/usr

    make
}

build_test_level=3
buld_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/bin/gzip $BUILD_PACK/bin
}
