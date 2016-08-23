#!/bin/bash

build_compile()
{
    sed -i 's/cp -p/cp/' build/make/Makefile

    mkdir libvpx-build
    cd libvpx-build

    ../configure         \
	--prefix=/usr    \
        --enable-shared  \
        --disable-static 

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

