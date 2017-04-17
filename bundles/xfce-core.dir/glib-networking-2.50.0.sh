#!/bin/bash

build_compile()
{
    ./configure          \
	--prefix=/usr    \
        --with-ca-certificates=/etc/ssl/ca-bundle.crt \
        --disable-static
    
    make
}

build_test_level=4
build_test()
{
    make -k test
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

