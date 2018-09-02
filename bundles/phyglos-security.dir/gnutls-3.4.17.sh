#!/bin/bash

build_compile()
{
    ./configure                        \
	--prefix=/usr                  \
	--without-p11-kit              \
	--with-default-trust-store-file=/etc/ssl/ca-bundle.crt 

    make
}

build_test_level=2
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
