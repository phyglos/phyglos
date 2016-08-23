#!/bin/bash

build_compile()
{
    perl Makefile.PL

    make
}


build_pack()
{
     make DESTDIR=$BUILD_PACK install UNINST=1
}


