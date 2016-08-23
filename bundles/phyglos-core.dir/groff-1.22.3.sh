#!/bin/bash

build_compile()
{
    PAGE=A4 \
    ./configure --prefix=/usr

    make -j1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

