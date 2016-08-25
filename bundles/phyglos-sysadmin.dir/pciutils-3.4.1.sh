#!/bin/bash

build_compile()
{
    make                         \
	PREFIX=/usr              \
	MANDIR=/usr/share/man    \
	SHAREDIR=/usr/share/misc \
	SHARED=yes
}

build_pack()
{
    make                                    \
	PREFIX=$BUILD_PACK/usr              \
	MANDIR=$BUILD_PACK/usr/share/man    \
	SHAREDIR=$BUILD_PACK/usr/share/misc \
	SHARED=yes                          \
	install install-lib      

    chmod -v 755 $BUILD_PACK/usr/lib/libpci.so
}

