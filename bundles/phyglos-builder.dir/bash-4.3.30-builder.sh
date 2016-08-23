#!/bin/bash

build_compile()
{
    ./configure \
	--prefix=$BANDIT_BUILDER_DIR \
        --without-bash-malloc

    make 
}

build_test_level=4
build_test()
{
    make tests
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -sv bash $BUILD_PACK$BANDIT_BUILDER_DIR/bin/sh
}
