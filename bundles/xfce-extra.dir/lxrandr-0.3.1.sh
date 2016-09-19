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
    update-desktop-database /usr/share/applications
    
    gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
}
