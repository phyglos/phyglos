#!/bin/sh

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/clucene-2.3.3.4-contribs_lib-1.patch
    
    mkdir build
    cd    build

    cmake -DCMAKE_INSTALL_PREFIX=/usr \
	  -DBUILD_CONTRIBS_LIB=ON ..

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
