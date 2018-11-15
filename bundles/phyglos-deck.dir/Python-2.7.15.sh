#!/bin/bash

build_compile()
{
    ./configure              \
	--prefix=/usr        \
        --enable-shared      \
        --with-system-expat  \
        --with-system-ffi    \
        --enable-unicode=ucs4 

    make
}

build_test_level=2
build_test()
{
    make -k test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 

    chmod -v 755 $BUILD_PACK/usr/lib/libpython2.7.so.1.0
}
