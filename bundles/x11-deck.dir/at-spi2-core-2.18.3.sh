#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--sysconfdir=/etc

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

