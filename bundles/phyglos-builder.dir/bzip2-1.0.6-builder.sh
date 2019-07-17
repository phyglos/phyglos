#!/bin/bash

build_compile()
{
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
    
    make
}

build_pack()
{
    make PREFIX=$BUILD_PACK$BANDIT_BUILDER_DIR install
}
