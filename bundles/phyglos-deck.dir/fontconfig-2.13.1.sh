#!/bin/bash

build_compile()
{
    rm -f src/fcobjshash.h
    
    ./configure              \
        --prefix=/usr        \
        --sysconfdir=/etc    \
        --localstatedir=/var \
        --disable-docs       \
        --docdir=/usr/share/doc/fontconfig-2.13.1 

    make
}

build_test_level=4
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    install -v -dm755  $BUILD_PACK/usr/share/{man/man{1,3,5},doc/fontconfig-2.13.1/fontconfig-devel}
    install -v -m644 fc-*/*.1         $BUILD_PACK/usr/share/man/man1 
    install -v -m644 doc/*.3          $BUILD_PACK/usr/share/man/man3
    install -v -m644 doc/fonts-conf.5 $BUILD_PACK/usr/share/man/man5
    install -v -m644 doc/fontconfig-devel/* $BUILD_PACK/usr/share/doc/fontconfig-2.13.1/fontconfig-devel 
    install -v -m644 doc/*.{pdf,sgml,txt,html} $BUILD_PACK/usr/share/doc/fontconfig-2.13.1
}
