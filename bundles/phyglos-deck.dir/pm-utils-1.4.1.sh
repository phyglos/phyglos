#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
        --docdir=/usr/share/doc/pm-utils-1.4.1
	
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

