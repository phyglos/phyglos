#!/bin/bash

build_compile()
{
    ./configure \
	--prefix=$BANDIT_BUILDER_DIR \
	--enable-install-program=hostname

    make
}

build_test_level=1
build_test()
{
    make RUN_EXPENSIVE_TESTS=yes check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
