#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/sysvinit-2.93-consolidated-1.patch
    
    make 
}

build_pack()
{
    make ROOT=$BUILD_PACK install
}
