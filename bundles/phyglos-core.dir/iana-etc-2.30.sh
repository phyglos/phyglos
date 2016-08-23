#!/bin/bash

build_compile()
{
    make 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
