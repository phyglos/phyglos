#!/bin/bash

build_compile()
{
    # Always build with an empty CCache
    bandit_system_has ccache && ccache -C

    # Remove unneeded encryptation and compression methods
    ./config                  \
	--prefix=/usr         \
        --openssldir=/etc/ssl \
        --libdir=lib          \
        shared                \
        no-idea               \
	no-rc5                \
	no-psk                \
	no-ssl2               \
	no-ssl3               \
	no-weak-ssl-ciphers   \
        no-comp               \
        no-zlib

    make depend
    make
}

build_test_level=1
build_test()
{
    make -j1 test
}

build_pack()
{
    # Avoid installing static libraries
    sed -i 's# libcrypto.a##;s# libssl.a##' Makefile

    make INSTALL_PREFIX=$BUILD_PACK \
	MANDIR=/usr/share/man \
	MANSUFFIX=ssl \
	install 

    install -dv -m755 $BUILD_PACK/usr/share/doc/openssl-1.0.2k
    cp -vfr doc/*     $BUILD_PACK/usr/share/doc/openssl-1.0.2k
}
