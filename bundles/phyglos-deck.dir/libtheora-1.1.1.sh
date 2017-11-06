#!/bin/bash

build_compile()
{
    sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c
    
    ./configure          \
	--prefix=/usr    \
	--disable-static
    
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

