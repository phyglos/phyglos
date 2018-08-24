#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/nss-3.26-standalone-1.patch

    cd nss
    
    make -j1                                \
	BUILD_OPT=1                         \
	NSPR_INCLUDE_DIR=/usr/include/nspr  \
	USE_SYSTEM_ZLIB=1                   \
	ZLIB_LIBS=-lz                       \
	$([ "$BANDIT_TARGET_ARCH" = x86_64 ] && echo USE_64=1) \
	$([ -f /usr/include/sqlite3.h ]      && echo NSS_USE_SYSTEM_SQLITE=1)
}

build_pack()
{
     cd ../dist

     bandit_mkdir $BUILD_PACK/usr/lib
     install -v -m755 Linux*/lib/*.so              $BUILD_PACK/usr/lib
     install -v -m644 Linux*/lib/{*.chk,libcrmf.a} $BUILD_PACK/usr/lib

     bandit_mkdir $BUILD_PACK/usr/include/nss
     install -v -m755 -d              $BUILD_PACK/usr/include/nss
     cp -v -RL {public,private}/nss/* $BUILD_PACK/usr/include/nss
     chmod -v 644                     $BUILD_PACK/usr/include/nss/*

     bandit_mkdir $BUILD_PACK/usr/bin
     install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} $BUILD_PACK/usr/bin

     bandit_mkdir $BUILD_PACK/usr/lib/pkgconfig
     install -v -m644 Linux*/lib/pkgconfig/nss.pc  $BUILD_PACK/usr/lib/pkgconfig
}
