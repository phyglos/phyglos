#!/bin/bash

build_compile()
{
    make
}

build_pack()
{
    make PREFIX=$BUILD_PACK$BANDIT_BUILDER_DIR install
}
