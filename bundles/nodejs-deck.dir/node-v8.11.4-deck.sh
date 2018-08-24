#!/bin/bash
    
build_compile()
{
    PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig \
    ./configure                \
        --prefix=/usr          \
        --with-intl=small-icu  \
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
    ln -sf node $BUILD_PACK/usr/share/doc/node-8.11.4
}
