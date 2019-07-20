#!/bin/bash 

build_compile()
{
    make mrproper
}

build_pack()
{
    make INSTALL_HDR_PATH=dest headers_install

    bandit_mkdir $BUILD_PACK$BANDIT_BUILDER_DIR/include
    cp -rv dest/include/* $BUILD_PACK$BANDIT_BUILDER_DIR/include
}
