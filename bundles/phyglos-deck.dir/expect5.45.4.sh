#!/bin/bash


build_compile()
{
    ./configure                 \
	--prefix=/usr           \
	--mandir=/usr/share/man \
        --with-tcl=/usr/lib     \
        --with-tclinclude=/usr/include

    make
}

build_test_level=4
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/lib
    ln -svf expect5.45/libexpect5.45.4.so $BUILD_PACK/usr/lib
}
