#!/bin/bash

build_compile()
{
    unzip -q $BUILD_SOURCES/sqlite-doc-3240000.zip

    CFLAGS="-O2                               \
            -DSQLITE_ENABLE_FTS4=1            \
            -DSQLITE_ENABLE_FTS3_TOKENIZER=1  \
            -DSQLITE_ENABLE_COLUMN_METADATA=1 \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
            -DSQLITE_SECURE_DELETE=1          \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1"
    ./configure           \
	--prefix=/usr     \
        --disable-static  \

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    bandit_mkdir $BUILD_PACK/usr/share/doc/sqlite-3.24.0 
    cp -R sqlite-doc-3240000/* $BUILD_PACK/usr/share/doc/sqlite-3.24.0
}

