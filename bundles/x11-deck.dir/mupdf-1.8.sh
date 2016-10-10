#!/bin/bash

build_compile()
{
    cd mupdf-1.8-source
    
    rm -vrf thirdparty/curl     
    rm -vrf thirdparty/freetype 
    rm -vrf thirdparty/jpeg     
    rm -vrf thirdparty/openjpeg 
    rm -vrf thirdparty/zlib     

    patch -Np1 -i $BUILD_SOURCES/mupdf-1.8-openjpeg21-1.patch

    make build=release
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/bin
    install -v -m 755 build/release/mupdf-x11-curl $BUILD_PACK/usr/bin/mupdf

    bandit_mkdir $BUILD_PACK/usr/share/man/man1
    install -v -m 644 docs/man/mupdf.1 $BUILD_PACK/usr/share/man/man1/
}
