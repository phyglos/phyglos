#!/bin/bash 

build_pack()
{
    bandit_mkdir $BUILD_PACK/var/lib/phyglos/linux-configs
    cp -v linux-$PHY_KERNEL_VER-$PHY_KERNEL_ARCH-* $BUILD_PACK/var/lib/phyglos/linux-configs
}

