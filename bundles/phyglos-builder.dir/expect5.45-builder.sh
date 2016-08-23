#!/bin/bash

build_compile()
{
    cp -v configure{,.orig}
    sed 's:/usr/local/bin:/bin:' configure.orig > configure

    ./configure \
	--prefix=$BANDIT_BUILDER_DIR                  \
        --with-tcl=$BANDIT_BUILDER_DIR/lib            \
        --with-tclinclude=$BANDIT_BUILDER_DIR/include

    make
}

build_test_level=4
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK SCRIPTS="" install
}
