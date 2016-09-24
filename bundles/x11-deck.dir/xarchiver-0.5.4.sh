#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/xarchiver-0.5.4-fixes-1.patch

    ./autogen.sh \
	--prefix=/usr               \
        --libexecdir=/usr/lib/xfce4 \
        --disable-gtk3              \
        --docdir=/usr/share/doc/xarchiver-0.5.4
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
         DOCDIR=/usr/share/doc/xarchiver-0.5.4 \
	 install   
}

install_setup()
{
    update-desktop-database
    
    gtk-update-icon-cache -qt -f --include-image-data /usr/share/icons/hicolor
}
