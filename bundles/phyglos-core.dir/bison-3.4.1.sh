#!/bin/bash

build_compile()
{
    sed -i '6855 s/mv/cp/' Makefile.in
    
    ./configure       \
	--prefix=/usr \
	--docdir=/usr/share/doc/bison-3.4.1

    make -j1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

