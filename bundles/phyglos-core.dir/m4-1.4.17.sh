#!/bin/bash

build_compile()
{
    ./configure --prefix=/usr

    make
}

build_test_level=3
build_test()
{
    make check
}

build_pack()
{
    make prefix=$BUILD_PACK/usr install
}
