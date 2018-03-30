#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr         \
	--without-zenmap      \
	--without-nmap-update \
	--with-liblua=included

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

