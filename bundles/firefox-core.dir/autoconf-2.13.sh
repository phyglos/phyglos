#!/bin/bash

build_compile()
{
    # Prepare bespoke version of Autoconf for Firefox, Thunderbird and others
    patch -Np1 -i $BUILD_SOURCES/autoconf-2.13-consolidated_fixes-1.patch
    mv -v autoconf.texi autoconf213.texi
    rm -v autoconf.info
    
    ./configure \
	--prefix=/usr \
	--program-suffix=-2.13
    
    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    install -v -m644 autoconf213.info $BUILD_PACK/usr/share/info/autoconf-2.13.info
}

