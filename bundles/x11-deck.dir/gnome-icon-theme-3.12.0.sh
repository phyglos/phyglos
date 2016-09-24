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
    gtk-update-icon-cache -qf /usr/share/icons/gnome
}
