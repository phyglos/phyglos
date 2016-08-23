#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr         \
        --localstatedir=/var  \
	--with-x-toolkit=${EMACS_X_TOOLKIT}
	
    make bootstrap
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    chown -R root:root $BUILD_PACK/usr/share/emacs/24.5
}

install_setup()
{
    gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
    update-desktop-database
}
