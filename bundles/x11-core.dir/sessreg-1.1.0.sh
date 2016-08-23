#!/bin/bash


build_compile()
{
    sed -e 's/$(CPP) $(DEFS)/$(CPP) -P $(DEFS)/' -i man/Makefile.in 
    ./configure $PHY_XORG_CONFIG
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
