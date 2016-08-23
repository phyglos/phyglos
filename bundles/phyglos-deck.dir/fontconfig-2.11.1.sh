#!/bin/bash


build_compile()
{
    ./configure              \
	--prefix=/usr        \
        --sysconfdir=/etc    \
        --localstatedir=/var \
        --disable-docs       \
        --docdir=/usr/share/doc/fontconfig-2.11.1 

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
}
