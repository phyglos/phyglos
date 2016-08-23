#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--docdir=/usr/share/doc/xz-5.2.2

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

    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} $BUILD_PACK/bin

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/liblzma.so.* $BUILD_PACK/lib
    ln -svf ../../lib/$(readlink $BUILD_PACK/usr/lib/liblzma.so) $BUILD_PACK/usr/lib/liblzma.so
}
