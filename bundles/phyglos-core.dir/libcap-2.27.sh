#!/bin/bash

build_compile()
{
    sed -i '/install.*STALIBNAME/d' libcap/Makefile

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	prefix=/usr          \
	lib=/lib             \
	RAISE_SETFCAP=no     \
        install

    chmod -v 755 $BUILD_PACK/usr/lib/libcap.so

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libcap.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libcap.so) $BUILD_PACK/usr/lib/libcap.so
}
