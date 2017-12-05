#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc \
	--disable-static  \
	--with-modules    \
	--with-gslib      \
	--with-rsvg       \
	--with-dejavu-font-dir=/usr/share/fonts/X11-TTF
	
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
