#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr         \
        --localstatedir=/var  

    make bootstrap
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    chown -R root:root $BUILD_PACK/usr/share/emacs/24.5
}

