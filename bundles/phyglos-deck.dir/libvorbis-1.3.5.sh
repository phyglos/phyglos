#!/bin/bash

build_compile()
{
    sed -i '/components.png \\/{n;d}' doc/Makefile.in
    
    ./configure          \
	--prefix=/usr    \
        --disable-static
    
    make
}

build_test_level=4
build_test()
{
    make LIBS=-lm check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/libvorbis-1.3.5
    cp -v doc/Vorbis* $BUILD_PACK/usr/share/doc/libvorbis-1.3.5
}

