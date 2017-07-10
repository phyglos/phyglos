#!/bin/bash

build_compile()
{
    ./configure                 \
	--prefix=/usr           \
	--mandir=/usr/share/man 

    make 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 

    install -v -d -m755 $BUILD_PACK/usr/share/doc/links-2.14
    install -v -m644 doc/links_cal/* KEYS BRAILLE_HOWTO $BUILD_PACK/usr/share/doc/links-2.14
}

