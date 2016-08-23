#!/bin/bash
 

build_compile()
{
    ./configure $PHY_XORG_CONFIG \
	--with-xkb-rules-symlink=xorg
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
