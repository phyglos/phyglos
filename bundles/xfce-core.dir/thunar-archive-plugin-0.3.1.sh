#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    # Add support for xarchiver
    ln -sf /usr/lib/xfce4/thunar-archive-plugin/xarchiver.tap $BUILD_PACK/usr/libexec/thunar-archive-plugin/xarchiver.tap 
}
