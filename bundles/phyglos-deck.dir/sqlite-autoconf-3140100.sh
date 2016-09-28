#!/bin/bash

build_compile()
{
    unzip -q $BUILD_SOURCES/sqlite-doc-3140100.zip

    CFLAGS="-O2                               \
            -DSQLITE_ENABLE_FTS3=1            \
            -DSQLITE_ENABLE_COLUMN_METADATA=1 \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1   \
            -DSQLITE_ENABLE_DBSTAT_VTAB=1     \
            -DSQLITE_SECURE_DELETE=1"        
    ./configure           \
	--prefix=/usr     \
        --disable-static  \

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    bandit_mkdir $BUILD_PACK/usr/share/doc/sqlite-3.14.1 
    cp -R sqlite-doc-3140100/* $BUILD_PACK/usr/share/doc/sqlite-3.14.1
}

