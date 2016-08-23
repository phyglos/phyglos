#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr

    make 
}

build_test_level=2
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
