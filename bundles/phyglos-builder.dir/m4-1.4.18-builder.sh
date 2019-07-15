#!/bin/bash

build_compile()
{
    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
    echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h
    
    ./configure --prefix=$BANDIT_BUILDER_DIR

    make
}

build_test_level=4
build_test()
{
    make check 
}

build_pack()
{
    make prefix=$BUILD_PACK/$BANDIT_BUILDER_DIR install
}

