#!/bin/bash 

build_compile()
{
    ./configure                           \
	--prefix=/usr                     \
        --docdir=/usr/share/doc/pcre-8.43 \
        --enable-unicode-properties       \
        --enable-pcre16                   \
        --enable-pcre32                   \
        --enable-pcregrep-libz            \
        --enable-pcregrep-libbz2          \
        --enable-pcretest-libreadline     \
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

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libpcre.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libpcre.so) $BUILD_PACK/usr/lib/libpcre.so
}
