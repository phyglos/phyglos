#!/bin/bash

build_compile()
{
    make lib
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/include
    install -vm644 linear.h       $BUILD_PACK/usr/include
    
    bandit_mkdir $BUILD_PACK/usr/lib
    install -vm755 liblinear.so.3 $BUILD_PACK/usr/lib
    ln -sfv liblinear.so.3        $BUILD_PACK/usr/lib/liblinear.so
}

