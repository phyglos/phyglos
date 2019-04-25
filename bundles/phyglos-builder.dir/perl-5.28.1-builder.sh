#!/bin/bash

build_compile()
{
    sh Configure -des \
       -Dprefix=$BANDIT_BUILDER_DIR \
       -Dlibs=-lm \
       -Uloclibpth \
       -Ulocincpth

    make
}

build_pack()
{
    mkdir -p $BUILD_PACK$BANDIT_BUILDER_DIR/bin
    cp -v perl cpan/podlators/pod2man $BUILD_PACK$BANDIT_BUILDER_DIR/bin

    mkdir -p $BUILD_PACK$BANDIT_BUILDER_DIR/lib/perl5/5.28.1
    cp -Rv lib/* $BUILD_PACK$BANDIT_BUILDER_DIR/lib/perl5/5.28.1
}
