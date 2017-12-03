#!/bin/bash

build_compile()
{  
    ./configure           \
	--prefix=/usr     \
	--disable-x11     \
	--disable-wayland \
	--disable-opencv  \
	--with-package-name="GStreamer Bad Plugins 1.12.2" \
	--with-package-origin="http://www.phyglos.org"

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

