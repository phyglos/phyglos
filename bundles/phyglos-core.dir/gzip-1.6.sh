#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--bindir=/bin

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

    bandit_mkdir $BUILD_PACK/usr/bin
    mv -v $BUILD_PACK/bin/{gzexe,uncompress,zcmp,zdiff,zegrep} $BUILD_PACK/usr/bin
    mv -v $BUILD_PACK/bin/{zfgrep,zforce,zgrep,zless,zmore,znew} $BUILD_PACK/usr/bin
}
