#!/bin/bash

build_compile()
{   
    tar -xf $BUILD_SOURCES/poppler-data-0.4.7.tar.gz

    ./configure                     \
	--prefix=/usr               \
	--sysconfdir=/etc           \
	--disable-static            \
	--enable-build-type=release \
	--enable-cmyk               \
	--enable-xpdf-headers       \
	--enable-libcurl            \
	--enable-zlib               \
	--disable-poppler-qt4       \
	--disable-poppler-qt5       \
	--disable-gtk-test
    
    make
}


build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir  $BUILD_PACK/usr/share/doc/poppler-0.41.0
    install -v -m644 README*   $BUILD_PACK/usr/share/doc/poppler-0.41.0
    cp -vr glib/reference/html $BUILD_PACK/usr/share/doc/poppler-0.41.0

    # Install additional encoding data
    cd poppler-data-0.4.7

    make DESTDIR=$BUILD_PACK install

    cd ..
}
