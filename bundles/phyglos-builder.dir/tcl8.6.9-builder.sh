#!/bin/bash

build_compile()
{
    cd unix
    
    ./configure \
        --prefix=$BANDIT_BUILDER_DIR

    make
}

build_test_level=4
build_test()
{
    TZ=UTC make test   
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    chmod -v u+w $BUILD_PACK$BANDIT_BUILDER_DIR/lib/libtcl8.6.so

    make DESTDIR=$BUILD_PACK install-private-headers

    ln -sv tclsh8.6 $BUILD_PACK$BANDIT_BUILDER_DIR/bin/tclsh
}
