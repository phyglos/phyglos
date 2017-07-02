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
        no-comp                  \
        no-zlib                  \
        no-idea                  \
        no-psk                   \
        no-rc5                   \
        no-ssl3                  \
        no-weak-ssl-ciphers      

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
	 MANDIR=/usr/share/man \
	 MANSUFFIX=ssl \
	 install

    bandit_mkdir $BUILD_PACK/usr/share/doc/openssl-1.1.0f
    cp -vfr doc/* $BUILD_PACK/usr/share/doc/openssl-1.1.0f
}
