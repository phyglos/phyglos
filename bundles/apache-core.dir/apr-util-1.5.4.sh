#!/bin/bash

build_compile()
{
    ./configure               \
	--prefix=/usr         \
        --with-apr=/usr       \
        --with-openssl=/usr   \
        --with-crypto
    
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
}

