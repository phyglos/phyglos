#!/bin/sh

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/openldap-2.4.44-consolidated-2.patch
    
    autoconf

    ./configure \
	--prefix=/usr     \
	--sysconfdir=/etc \
	--disable-static  \
	--enable-dynamic  \
	--disable-debug   \
	--disable-slapd

    make depend
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
