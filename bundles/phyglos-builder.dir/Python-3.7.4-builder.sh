#!/bin/bash

build_compile()
{
    sed -i '/def add_multiarch_paths/a \        return' setup.py
    
    ./configure                      \
	--prefix=$BANDIT_BUILDER_DIR \
	--without-ensurepip
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

