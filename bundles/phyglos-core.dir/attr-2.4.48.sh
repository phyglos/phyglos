#!/bin/bash

build_compile()
{
    ./configure                             \
	--prefix=/usr                       \
        --bindir=/bin                       \
        --sysconfdir=/etc                   \
        --docdir=/usr/share/doc/attr-2.4.48 \
        --disable-static

    make
}

build_test_level=1
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libattr.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libattr.so) $BUILD_PACK/usr/lib/libattr.so
}
