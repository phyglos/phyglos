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
    bandit_mkdir $BUILD_PACK$BANDIT_BUILDER_DIR/lib

    case $(uname -m) in
	x86_64) 
	    ln -sv lib $BUILD_PACK$BANDIT_BUILDER_DIR/lib64 
	    ;;
    esac

    make DESTDIR=$BUILD_PACK install
}
