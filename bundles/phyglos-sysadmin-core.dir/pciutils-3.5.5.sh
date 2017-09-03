#!/bin/bash

build_compile()
{
    make                           \
	PREFIX=/usr                \
	MANDIR=/usr/share/man      \
	SHAREDIR=/usr/share/hwdata \
	SHARED=yes
}

build_pack()
{
    make                                      \
	PREFIX=$BUILD_PACK/usr                \
	MANDIR=$BUILD_PACK/usr/share/man      \
	SHAREDIR=$BUILD_PACK/usr/share/hwdata \
	SHARED=yes                            \
	install install-lib      

    chmod -v 755 $BUILD_PACK/usr/lib/libpci.so
}

