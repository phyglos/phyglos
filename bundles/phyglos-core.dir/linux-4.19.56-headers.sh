#!/bin/bash 

build_compile()
{
    make mrproper
}
       
build_pack()
{
    make INSTALL_HDR_PATH=dest headers_install

    find dest/include \( -name .install -o -name ..install.cmd \) -delete

    bandit_mkdir $BUILD_PACK/usr/include
    cp -rv dest/include/* $BUILD_PACK/usr/include
}
