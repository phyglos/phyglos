#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
        --disable-static 

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
