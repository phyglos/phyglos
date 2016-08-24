#!/bin/bash

build_compile()
{
    cd unix
    ./configure       \
	--prefix=/usr \
	--mandir=/usr/share/man \
	$([ $(uname -m) = x86_64 ] && echo --enable-64bit )

    make

    sed -e "s@^\(TK_SRC_DIR='\).*@\1/usr/include'@" \
	-e "/TK_B/s@='\(-L\)\?.*unix@='\1/usr/lib@" \
	-i tkConfig.sh
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make INSTALL_ROOT=$BUILD_PACK install

    make INSTALL_ROOT=$BUILD_PACK install-private-headers

    bandit_mkdir $BUILD_PACK/usr/bin 
    ln -v -sf wish8.6 $BUILD_PACK/usr/bin/wish
    
    chmod -v 755 $BUILD_PACK/usr/lib/libtk8.6.so
}
