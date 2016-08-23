#!/bin/bash

build_compile()
{
    perl Makefile.PL

    make
}

build_test_level=3
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
