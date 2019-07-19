#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    ../configure				\
	--prefix=$BANDIT_BUILDER_DIR		\
	--with-sysroot=$BANDIT_HOST_TGT_MNT	\
	--with-lib-path=$BANDIT_BUILDER_DIR/lib \
	--target=$BANDIT_BUILDER_TRIPLET	\
	--disable-nls				\
	--disable-werror

    make 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
