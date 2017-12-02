#!/bin/bash

build_compile()
{
    # Always build with an empty CCache
    bandit_system_has ccache && ccache -C

    # Remove unneeded encryptation and compression methods
    ./config                     \
        --prefix=/usr            \
        --openssldir=/etc/ssl    \
        --libdir=lib             \
        shared                   \
        no-idea                  \
        no-rc5                   \
        no-psk                   \
        no-ssl3                  \
        no-weak-ssl-ciphers      \
        no-comp                  \
        no-zlib

    make depend
    make 
}

build_test_level=1
build_test()
{
    make test
}

build_pack()
{
    # Disable static libraries
    sed -i 's# libcrypto.a##;s# libssl.a##;/INSTALL_LIBS/s#libcrypto.a##' Makefile

    make DESTDIR=$BUILD_PACK \
	 MANSUFFIX=ssl \
	 install

    bandit_mkdir $BUILD_PACK/usr/share/doc/openssl-1.1.0g
    cp -vfr doc/* $BUILD_PACK/usr/share/doc/openssl-1.1.0g
}
