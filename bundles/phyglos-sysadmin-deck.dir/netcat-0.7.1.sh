#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

