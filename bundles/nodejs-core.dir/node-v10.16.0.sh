#!/bin/bash
    
build_compile()
{
    ./configure                \
        --prefix=/usr          \
        --without-npm          \
        --with-intl=system-icu \
        --shared-cares         \
        --shared-openssl       \
        --shared-zlib

    make
}

build_test_level=4
build_test()
{
    make -j1 test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc
    ln -sf node $BUILD_PACK/usr/share/doc/node-10.16.0
}
