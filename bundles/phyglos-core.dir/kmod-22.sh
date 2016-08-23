#!/bin/bash

build_compile()
{
    ./configure                \
	--prefix=/usr          \
	--bindir=/bin          \
	--sysconfdir=/etc      \
	--with-rootlibdir=/lib \
	--with-xz              \
	--with-zlib

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

    bandit_mkdir $BUILD_PACK/sbin
    for target in depmod insmod modinfo modprobe rmmod; do
	ln -sv ../bin/kmod $BUILD_PACK/sbin/$target
    done

    bandit_mkdir $BUILD_PACK/bin
    ln -sv kmod $BUILD_PACK/bin/lsmod
}
