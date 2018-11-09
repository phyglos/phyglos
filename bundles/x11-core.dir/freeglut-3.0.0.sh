#!/bin/bash

build_compile()
{
    mkdir build
    cd    build

    CMAKE_LIBRARY_PATH=$XORG_PREFIX/lib           \
    CMAKE_INCLUDE_PATH=$XORG_PREFIX/include       \
    cmake -DCMAKE_INSTALL_PREFIX=$XORG_PREFIX/usr \
          -DCMAKE_BUILD_TYPE=Release              \
	  -DFREEGLUT_BUILD_DEMOS=OFF              \
	  -DFREEGLUT_BUILD_STATIC_LIBS=OFF        \
	  ..

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
