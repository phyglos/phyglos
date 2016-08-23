#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--with-x11

    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    gdk-pixbuf-query-loaders --update-cache
}
