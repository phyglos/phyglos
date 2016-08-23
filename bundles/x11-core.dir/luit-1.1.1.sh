#!/bin/bash


build_compile()
{
    sed -i -e "s@#ifdef HAVE_CONFIG_H@#ifdef _XOPEN_SOURCE\n#  undef _XOPEN_SOURCE \n#  define _XOPEN_SOURCE 600 \n#endif \n\n&@" sys.c 
    ./configure $PHY_XORG_CONFIG
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
