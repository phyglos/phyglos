#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/bzip2-1.0.6-install_docs-1.patch

    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

    make -f Makefile-libbz2_so
    make clean

    make
}

build_pack()
{
    make PREFIX=$BUILD_PACK/usr install

    bandit_mkdir $BUILD_PACK/bin
    cp -v bzip2-shared $BUILD_PACK/bin/bzip2

    bandit_mkdir $BUILD_PACK/lib
    cp -av libbz2.so* $BUILD_PACK/lib
    ln -sv ../../lib/libbz2.so.1.0 $BUILD_PACK/usr/lib/libbz2.so

    rm -v $BUILD_PACK/usr/bin/{bunzip2,bzcat,bzip2}
    ln -sv bzip2 $BUILD_PACK/bin/bunzip2
    ln -sv bzip2 $BUILD_PACK/bin/bzcat
}
