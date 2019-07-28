#!/bin/bash

build_compile()
{ 
    tar -x --strip-components=2 \
        -C docs \
        -f $BUILD_SOURCES/freetype-doc-2.10.1.tar.xz

    sed -r "s:.*(AUX_MODULES.*valid):\1:" \
        -i modules.cfg                       

    sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
        -i include/freetype/config/ftoption.h   

    ./configure                  \
        --prefix=/usr            \
        --enable-freetype-config \
        --disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    install -v -m755 -d $BUILD_PACK/usr/share/doc/freetype-2.10.1
    cp -vR docs/*       $BUILD_PACK/usr/share/doc/freetype-2.10.1
    rm -v               $BUILD_PACK/usr/share/doc/freetype-2.10.1/freetype-config.1
}
