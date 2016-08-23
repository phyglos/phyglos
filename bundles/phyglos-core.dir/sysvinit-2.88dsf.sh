#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/sysvinit-2.88dsf-consolidated-1.patch
    
    make -C src
}

build_pack()
{
    make ROOT=$BUILD_PACK -C src install
}
