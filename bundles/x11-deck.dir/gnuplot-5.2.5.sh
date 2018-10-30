#!/bin/bash

build_compile()
{
    ./configure             \
	--prefix=/usr       \
	--disable-wxwidgets \
	--without-libcerf   \
	--without-lua       \
	--with-qt=no        \
	--with-x
    
    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
