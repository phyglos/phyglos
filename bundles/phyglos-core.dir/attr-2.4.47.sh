#!/bin/bash

build_compile()
{
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
    sed -i -e "/SUBDIRS/s|man2||" man/Makefile

    ./configure         \
	--prefix=/usr   \
        --bindir=/bin   \
        --disable-static

    make
}

build_test_level=3
build_test()
{
    make -j1 tests root-tests
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/lib

    make DIST_ROOT=$BUILD_PACK install install-dev install-lib

    chmod -v 755 $BUILD_PACK/usr/lib/libattr.so

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libattr.so.* $BUILD_PACK/lib

    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libattr.so) $BUILD_PACK/usr/lib/libattr.so
}
