#!/bin/bash

build_compile()
{   
    rm -rf thirdparty/curl     
    rm -rf thirdparty/freetype 
    rm -rf thirdparty/harfbuzz
    rm -rf thirdparty/jpeg     
    rm -rf thirdparty/openjpeg 
    rm -rf thirdparty/zlib     

    sed '/OPJ_STATIC$/d' -i source/fitz/load-jpx.c 

    patch -Np1 -i $BUILD_SOURCES/mupdf-1.10a-shared_libs-1.patch 

    # Prevent from checking openssl (From Arch Linux)
    sed -i 's/pkg-config --exists \(libcrypto\|openssl\)/false/' Makerules

    # Prevent from building mupfd-gl 
    sed 's/HAVE_GLFW/GLFW_NO/' -i Makefile
    local HAVE_GLFW=yes

    make build=release
}

build_pack()
{
    make prefix=/usr                       \
	 build=release                     \
	 docdir=/usr/share/doc/mupdf-1.10a \
	 DESTDIR=$BUILD_PACK install

    ln -sfv mupdf-x11 $BUILD_PACK/usr/bin/mupdf
}
