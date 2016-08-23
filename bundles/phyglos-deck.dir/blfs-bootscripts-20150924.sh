#!/bin/bash

build_pack()
{
    bandit_mkdir $BUILD_PACK/opt/blfs-bootscripts
    cp -vR * $BUILD_PACK/opt/blfs-bootscripts
}

