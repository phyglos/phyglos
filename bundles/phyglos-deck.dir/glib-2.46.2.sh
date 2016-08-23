#!/bin/bash

build_compile()
{
    ./configure            \
	--prefix=/usr      \
	--with-pcre=system \
	--disable-fam

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
