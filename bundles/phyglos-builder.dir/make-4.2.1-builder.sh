#!/bin/bash

build_compile()
{
    sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c

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

