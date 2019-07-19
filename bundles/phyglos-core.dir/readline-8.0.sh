#!/bin/bash

build_compile()
{
    sed -i '/MV.*old/d' Makefile.in
    sed -i '/{OLDSUFF}/c:' support/shlib-install

    ./configure		 \
	--prefix=/usr	 \
	--disable-static \
	--docdir=/usr/share/doc/readline-8.0

    make SHLIB_LIBS="-L${BANDIT_BUILDER_DIR}/lib -lncurses"
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	 SHLIB_LIBS="-L ${BANDIT_BUILDER_DIR}/lib -lncurses" \
	 install

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/lib{readline,history}.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libreadline.so) $BUILD_PACK/usr/lib/libreadline.so
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libhistory.so ) $BUILD_PACK/usr/lib/libhistory.so

    install -v -m644 doc/*.{ps,pdf,html,dvi} $BUILD_PACK/usr/share/doc/readline-8.0
}
