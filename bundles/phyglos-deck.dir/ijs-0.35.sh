#!/bin/bash

build_compile()
{
    ./configure                 \
	--prefix=/usr           \
        --mandir=/usr/share/man \
        --enable-shared         \
        --disable-static
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
