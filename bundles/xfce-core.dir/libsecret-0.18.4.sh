#!/bin/bash

build_compile()
{
    ./configure                  \
	--prefix=/usr            \
	--enable-gtk-doc=no      \
	--enable-gtk-doc-html=no \
	--enable-gtk-doc-pdf=no  \
	--disable-manpages       \
	--disable-static
    
    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

