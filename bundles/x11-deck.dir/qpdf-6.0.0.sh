#!/bin/bash

build_compile()
{   
    ./configure           \
	--prefix=/usr     \
	--disable-static  \
        --docdir=/usr/share/doc/qpdf-6.0.0
    
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
