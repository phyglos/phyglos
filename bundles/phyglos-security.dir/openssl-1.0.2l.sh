#!/bin/bash

build_compile()
{
    # Always build with an empty CCache
    bandit_system_has ccache && ccache -C

    patch -Np1 -i $BUILD_SOURCES/openssl-1.0.2l-compat_versioned_symbols-1.patch
    
    # Remove unneeded encryptation and compression methods
    ./config                     \
        --prefix=/usr            \
        --openssldir=/etc/ssl    \
        --libdir=lib/openssl-1.0 \
        shared                   \
        no-idea                  \
        no-rc5                   \
        no-psk                   \
        no-ssl2                  \
        no-ssl3                  \
        no-weak-ssl-ciphers      \
        no-comp                  \
        no-zlib

    make depend
    make -j1
}

build_test_level=1
build_test()
{
    make -j1 test
}

build_pack()
{
    make INSTALL_PREFIX=$BUILD_PACK \
	MANDIR=/usr/share/man \
	MANSUFFIX=ssl \
	install_sw

    mv -v  $BUILD_PACK/usr/lib/openssl-1.0/lib{crypto,ssl}.so.1.0.0 $BUILD_PACK/usr/lib 
    ln -sv ../libssl.so.1.0.0         $BUILD_PACK/usr/lib/openssl-1.0        
    ln -sv ../libcrypto.so.1.0.0      $BUILD_PACK/usr/lib/openssl-1.0        

    mv -v $BUILD_PACK/usr/include/openssl $BUILD_PACK/usr/include/openssl-1.0
    
    sed 's@/include$@/include/openssl-1.0@' -i $BUILD_PACK/usr/lib/openssl-1.0/pkgconfig/*.pc
}
