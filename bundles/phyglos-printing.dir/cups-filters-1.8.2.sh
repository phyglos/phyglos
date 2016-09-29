#!/bin/bash

build_compile()
{
    ./configure \
        --prefix=/usr                   \
        --sysconfdir=/etc               \
        --localstatedir=/var            \
        --without-rcdir                 \
        --disable-static                \
        --with-gs-path=/usr/bin/gs      \
        --with-pdftops-path=/usr/bin/gs \
        --docdir=/usr/share/doc/cups-filters-1.8.2   
    
    make
}

build_test_level=0
build_test()
{
    make -k check 2>&1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

