#!/bin/bash

build_compile()
{
    # Always build with an empty CCache
    which ccache 2>&1 >/dev/null
    [[ $? == 0 ]] && ccache -C

    # Remove unneeded encryptation methods
    ./config                  \
	--prefix=/usr         \
        --openssldir=/etc/ssl \
        --libdir=lib          \
        shared                \
        no-idea               \
	no-rc5                \
	no-ssl2               \
	no-ssl3               \
	no-weak-ssl-ciphers   \
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

    install -dv -m755 $BUILD_PACK/usr/share/doc/openssl-1.0.2h
    cp -vfr doc/*     $BUILD_PACK/usr/share/doc/openssl-1.0.2h
}
