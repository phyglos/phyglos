#!/bin/bash

build_compile()
{
    ./configure        \
	--prefix=/usr  \
	--localstatedir=/var/lib/locate

    make
}

build_test_level=3
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/find $BUILD_PACK/bin

    sed -i 's|find:=${BINDIR}|find:=/bin|' $BUILD_PACK/usr/bin/updatedb
}
