#!/bin/bash

build_compile()
{
    ./configure \
        --prefix=$BANDIT_BUILDER_DIR \
        --without-guile

    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

