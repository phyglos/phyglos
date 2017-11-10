#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
        --enable-dbus

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}
