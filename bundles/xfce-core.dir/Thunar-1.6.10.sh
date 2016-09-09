#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
        --docdir=/usr/share/doc/Thunar-1.6.10
    
    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
