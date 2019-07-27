#!/bin/bash

build_compile()
{
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

    ln -sfv pip3.7 $BUILD_PACK/usr/bin/pip3
    
    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.7m.so
    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.so
}

