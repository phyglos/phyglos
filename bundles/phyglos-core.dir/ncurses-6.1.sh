#!/bin/bash

build_compile()
{
    sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

    ./configure                 \
	--prefix=/usr           \
        --mandir=/usr/share/man \
        --with-shared           \
        --without-debug         \
        --without-normal        \
        --enable-pc-files       \
        --enable-widec

    make 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libncursesw.so.6* $BUILD_PACK/lib

    bandit_mkdir $BUILD_PACK/usr/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libncursesw.so) $BUILD_PACK/usr/lib/libncursesw.so
    for lib in ncurses form panel menu ; do
	rm -vf                    $BUILD_PACK/usr/lib/lib${lib}.so
	echo "INPUT(-l${lib}w)" > $BUILD_PACK/usr/lib/lib${lib}.so
	ln -sfv ${lib}w.pc        $BUILD_PACK/usr/lib/pkgconfig/${lib}.pc
    done

    rm -vf                     $BUILD_PACK/usr/lib/libcursesw.so
    echo "INPUT(-lncursesw)" > $BUILD_PACK/usr/lib/libcursesw.so
    ln -sfv libncurses.so      $BUILD_PACK/usr/lib/libcurses.so

    bandit_mkdir $BUILD_PACK/usr/share/doc/ncurses-6.1
    cp -v -R doc/* $BUILD_PACK/usr/share/doc/ncurses-6.1
}
