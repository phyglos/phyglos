#!/bin/bash

build_compile()
{
    sed "s/mawk//" -i configure

    ./configure \
        --prefix=$BANDIT_BUILDER_DIR \
        --with-shared             \
        --without-debug           \
        --without-ada             \
        --enable-widec            \
        --enable-overwrite

    make 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
