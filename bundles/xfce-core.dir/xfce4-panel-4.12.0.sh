#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc \
	--enable-gtk3

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
