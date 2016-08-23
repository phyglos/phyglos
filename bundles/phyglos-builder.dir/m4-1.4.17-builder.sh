#!/bin/bash

build_compile()
{
    ./configure --prefix=$BANDIT_BUILDER_DIR

    make
}

build_test_level=4
build_test()
{
    make check 
}

build_pack()
{
    make prefix=$BUILD_PACK/$BANDIT_BUILDER_DIR install
}

