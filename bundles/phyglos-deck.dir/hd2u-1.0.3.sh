#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr  

    make
}

build_pack()
{
    make BUILD_ROOT=$BUILD_PACK install
}
