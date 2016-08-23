#!/bin/bash

build_compile()
{
    # Enable Linux-PAM
    sed -i 's:LIBDIR:PAM_&:g' pam_cap/Makefile &&

    make
}

build_pack()
{
    # Disable isntalling static libraries
    sed -i '/install.*STALIBNAME/d' libcap/Makefile

    make DESTDIR=$BUILD_PACK install \
	prefix=/usr         \
	SBINDIR=/sbin       \
	lib=/lib            \
	PAM_LIBDIR=/lib     \
	RAISE_SETFCAP=yes

    chmod -v 755 $BUILD_PACK/usr/lib/libcap.so

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libcap.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libcap.so) $BUILD_PACK/usr/lib/libcap.so
}
