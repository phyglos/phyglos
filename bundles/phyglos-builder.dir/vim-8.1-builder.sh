#!/bin/bash

build_compile()
{
    ./configure                      \
        --prefix=$BANDIT_BUILDER_DIR \
        --with-features=tiny

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK$BANDIT_BUILDER_DIR/usr/bin
    ln -sv vim $BUILD_PACK$BANDIT_BUILDER_DIR/usr/bin/vi
}
