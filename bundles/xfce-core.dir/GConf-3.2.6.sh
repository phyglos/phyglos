#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
        --disable-orbit   \
        --disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc/gconf
    ln -s gconf.xml.defaults $BUILD_PACK/etc/gconf/gconf.xml.system
}
