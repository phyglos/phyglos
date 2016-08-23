#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
	--disable-introspection

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
