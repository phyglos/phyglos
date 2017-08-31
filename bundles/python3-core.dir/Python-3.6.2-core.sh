#!/bin/bash

build_compile()
{
    CXX="/usr/bin/g++"      \
    ./configure             \
	--prefix=/usr       \
	--enable-shared     \
	--with-system-expat \
	--with-system-ffi   \
	--without-ensurepip
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.6m.so
    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.so
}

