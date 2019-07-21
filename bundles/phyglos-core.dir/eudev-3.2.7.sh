#!/bin/bash

build_compile()
{
    tar -xvf $BUILD_SOURCES/udev-lfs-20171102.tar.bz2

    ./configure                 \
        --prefix=/usr           \
        --bindir=/sbin          \
        --sbindir=/sbin         \
        --libdir=/usr/lib       \
        --sysconfdir=/etc       \
        --libexecdir=/lib       \
        --with-rootprefix=      \
        --with-rootlibdir=/lib  \
        --enable-manpages       \
        --disable-static

    make
}

build_test_level=3
build_test()
{
    bandit_mkdir $BUILD_PACK/lib/udev/rules.d
    bandit_mkdir $BUILD_PACK/etc/udev/rules.d

    make check 
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/lib/udev/rules.d
    bandit_mkdir $BUILD_PACK/etc/udev/rules.d

    make DESTDIR=$BUILD_PACK install

    make -f udev-lfs-20171102/Makefile.lfs \
         DESTDIR=$BUILD_PACK \
         install

}

install_setup()
{
    # Create initial hardware database
    udevadm hwdb --update
}
