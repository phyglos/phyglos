#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr 
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    gtk-update-icon-cache -f /usr/share/icons/nuoveXT2
}
