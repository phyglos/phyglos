#!/bin/bash


build_compile()
{
    ./configure                        \
        --prefix=$PHY_XORG_PREFIX      \
        --enable-gles1                 \
        --enable-gles2                 \
        --enable-osmesa                \
	--enable-libdrm                \
        --enable-gbm                   

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
