#!/bin/bash

build_compile()
{
    ./configure                  \
        --prefix=/usr            \
        --enable-qt5             \
        --without-included-boost \
        --without-hunspell       \
        --without-aspell         \
        --without-enchant        \
        --with-included-mythes
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    update-desktop-database
    
    gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
}

