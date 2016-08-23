#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr 

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    glib-compile-schemas /usr/share/glib-2.0/schemas
}
