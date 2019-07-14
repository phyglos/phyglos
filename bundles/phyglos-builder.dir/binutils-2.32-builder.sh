#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    CC=$BANDIT_BUILDER_TRIPLET-gcc               \
    AR=$BANDIT_BUILDER_TRIPLET-ar                \
    RANLIB=$BANDIT_BUILDER_TRIPLET-ranlib        \
    ../configure                                 \
        --prefix=$BANDIT_BUILDER_DIR             \
        --disable-nls                            \
        --disable-werror                         \
        --with-lib-path=$BANDIT_BUILDER_DIR/lib  \
        --with-sysroot

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    make -C ld clean
    make -C ld DESTDIR=$BUILD_PACK LIB_PATH=/usr/lib:/lib

    bandit_mkdir $BUILD_PACK$BANDIT_BUILDER_DIR/bin
    cp -v ld/ld-new $BUILD_PACK$BANDIT_BUILDER_DIR/bin
}
