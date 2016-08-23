#!/bin/bash

build_compile()
{
    ./configure            \
	--prefix=/usr      \
	--sysconfdir=/etc  

    make
}

build_test_level=2
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/local/bin/
    ln -sv /usr/bin/ccache $BUILD_PACK/usr/local/bin/gcc
    ln -sv /usr/bin/ccache $BUILD_PACK/usr/local/bin/g++
    ln -sv /usr/bin/ccache $BUILD_PACK/usr/local/bin/cc
    ln -sv /usr/bin/ccache $BUILD_PACK/usr/local/bin/c++
}

