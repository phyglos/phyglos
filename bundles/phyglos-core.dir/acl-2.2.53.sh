#!/bin/bash

build_compile()
{
    ./configure				   \
	--prefix=/usr			   \
	--bindir=/bin			   \
	--libexecdir=/usr/lib		   \
	--docdir=/usr/share/doc/acl-2.2.53 \
	--disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libacl.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libacl.so) $BUILD_PACK/usr/lib/libacl.so
}
