#!/bin/bash 

build_compile()
{
    make mrproper

    make INSTALL_HDR_PATH=dest headers_install
}

build_pack()
{
    bandit_mkdir $BUILD_PACK$BANDIT_BUILDER_DIR/include
    cp -rv dest/include/* $BUILD_PACK$BANDIT_BUILDER_DIR/include
}
