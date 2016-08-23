#!/bin/bash

build_compile()
{
    ./configure                                  \
	--prefix=/usr                            \
        --exec-prefix=                           \
        --libdir=/usr/lib                        \
        --docdir=/usr/share/doc/procps-ng-3.3.11 \
        --disable-static                         \
        --disable-kill

    make
}

build_test()
{
    sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp

    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libprocps.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libprocps.so) $BUILD_PACK/usr/lib/libprocps.so
}
