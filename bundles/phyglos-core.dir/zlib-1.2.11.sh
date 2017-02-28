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

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libz.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libz.so) $BUILD_PACK/usr/lib/libz.so
}
