#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/kbd-2.0.3-backspace-1.patch

    sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
    sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in

    PKG_CONFIG_PATH=$BANDIT_BUILDER_DIR/lib/pkgconfig \
    ./configure          \
	--prefix=/usr    \
	--disable-vlock

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

    bandit_mkdir $BUILD_PACK/usr/share/doc/kbd-2.0.3
    cp -R -v docs/doc/* $BUILD_PACK/usr/share/doc/kbd-2.0.3
}
