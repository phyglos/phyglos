#!/bin/bash

build_compile()
{
    sed -i 's#pkgdata#doc#' doc/Makefile.am
    
    autoreconf -fi
    
    ./configure          \
	--prefix=/usr    \
        --enable-shared  \
        --disable-static \
        --docdir=/usr/share/doc/libatomic_ops-7.4.2
    
make
}

build_test_level=4
build_test()
{
    LD_LIBRARY_PATH=../src/.libs \
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/
    mv -v   /usr/share/libatomic_ops/*  $BUILD_PACK/usr/share/doc/libatomic_ops-7.4.2
    rm -vrf $BUILD_PACK/usr/share/libatomic_ops   
}
