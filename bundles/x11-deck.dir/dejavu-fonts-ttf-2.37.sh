#!/bin/bash

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/share/fonts/X11-TTF
    chmod 755    $BUILD_PACK/usr/share/fonts/X11-TTF
    install -v -m644 ttf/*.ttf    $BUILD_PACK/usr/share/fonts/X11-TTF

    bandit_mkdir $BUILD_PACK/usr/share/fontconfig/conf.avail
    install -v -m644 fontconfig/* $BUILD_PACK/usr/share/fontconfig/conf.avail
}

install_setup()
{
    fc-cache -v /usr/share/fonts/X11-TTF
}


