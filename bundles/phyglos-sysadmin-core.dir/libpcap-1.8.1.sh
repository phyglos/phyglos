#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--enable-bluetooth=no
    
    make
}

build_pack()
{
    sed -i '/INSTALL_DATA.*libpcap.a\|RANLIB.*libpcap.a/ s/^/#/' Makefile

    make DESTDIR=$BUILD_PACK install
}

