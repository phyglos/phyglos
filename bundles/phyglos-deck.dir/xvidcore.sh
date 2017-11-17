#!/bin/bash

build_compile()
{
    cd build/generic
    sed -i 's/^LN_S=@LN_S@/& -f -v/' platform.inc.in
    
    ./configure --prefix=/usr
    
    make
}

build_pack()
{
    sed -i '/libdir.*STATIC_LIB/ s/^/#/' Makefile
    make DESTDIR=$BUILD_PACK install
    
    chmod -v 755 $BUILD_PACK/usr/lib/libxvidcore.so.4.3

    bandit_mkdir $BUILD_PACK/usr/share/doc/xvidcore-1.3.3/examples
    cp -v ../../doc/*      $BUILD_PACK/usr/share/doc/xvidcore-1.3.3
    cp -v ../../examples/* $BUILD_PACK/usr/share/doc/xvidcore-1.3.3/examples
}
