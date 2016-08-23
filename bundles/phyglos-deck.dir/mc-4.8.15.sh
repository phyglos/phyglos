#!/bin/bash

build_compile()
{
    ./configure              \
	--prefix=/usr        \
        --sysconfdir=/etc    \
	--with-screen=slang  \
	--without-x          \
        --enable-charset 

    make
}

build_test_level=4
buld_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 

    bandit_mkdir $BUILD_PACK/usr/share/mc
    cp -v doc/keybind-migration.txt $BUILD_PACK/usr/share/mc
}
