#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/epdfview-0.1.8-fixes-2.patch

    ./configure       \
	--prefix=/usr 

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    for size in 24 32 48; do
	bandit_mkdir $BUILD_PACK/usr/share/icons/hicolor/${size}x${size}/apps
	ln -svf ../../../../epdfview/pixmaps/icon_epdfview-$size.png \
           $BUILD_PACK/usr/share/icons/hicolor/${size}x${size}/apps
    done
    unset size
}

install_setup()
{
    update-desktop-database
    
    gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
}

