#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/x265_2.3-enable_static-1.patch 

    mkdir bld 
    cd bld 

    cmake \
	-DCMAKE_INSTALL_PREFIX=/usr \
	-DENABLE_STATIC=OFF         \
	../source 

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

