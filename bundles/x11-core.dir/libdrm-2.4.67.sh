#!/bin/bash


build_compile()
{
    sed -e "/pthread-stubs/d" -i configure.ac 
    autoreconf -fiv 

    ./configure        \
	--prefix=/usr  \
        --enable-udev 

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
