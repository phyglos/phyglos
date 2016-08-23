#!/bin/bash

build_compile()
{
    tar -xf $BUILD_SOURCES/freetype-doc-2.6.3.tar.bz2 --strip-components=2 -C docs

    sed -e "/AUX.*.gxvalid/s@^# @@" \
        -e "/AUX.*.otvalid/s@^# @@" \
        -i  modules.cfg                       

    sed -re 's:.*(#.*SUBPIXEL.*) .*:\1:' \
        -i include/freetype/config/ftoption.h   

    ./configure       \
	--prefix=/usr \
	--disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    install -v -m755 -d $BUILD_PACK/usr/share/doc/freetype-2.6.3
    cp -vR docs/*       $BUILD_PACK/usr/share/doc/freetype-2.6.3
}
