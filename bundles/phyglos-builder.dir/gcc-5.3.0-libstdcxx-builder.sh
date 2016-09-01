#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    ../libstdc++-v3/configure           \
	--host=$BANDIT_BUILDER_TRIPLET        \
	--prefix=$BANDIT_BUILDER_DIR      \
	--disable-multilib              \
	--disable-nls                   \
	--disable-libstdcxx-threads     \
	--disable-libstdcxx-pch         \
	--with-gxx-include-dir=$BANDIT_BUILDER_DIR/$BANDIT_BUILDER_TRIPLET/include/c++/5.3.0

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
