#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--enable-gtk3 

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
