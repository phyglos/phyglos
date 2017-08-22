#!/bin/bash

build_compile()
{
    # Always set ABI
    local gmp_abi=""
    case $BANDIT_TARGET_ARCH in
	i?86)
	    gmp_abi=32
	    ;;
	x86_64)
	    gmp_abi=64
	    ;;
    esac

    ABI=$gmp_abi          \
    ./configure           \
	--prefix=/usr     \
	--enable-cxx      \
	--disable-static  \
	--docdir=/usr/share/doc/gmp-6.1.0

    make
    make html
}

build_test_level=1
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    make DESTDIR=$BUILD_PACK install-html
}
