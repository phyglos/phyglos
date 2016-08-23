#!/bin/bash

build_compile()
{
    unzip -q $BUILD_SOURCES/sqlite-doc-3110100.zip

    ./configure           \
	--prefix=/usr     \
        --disable-static  \
        CFLAGS="-g -O2                            \
            -DSQLITE_ENABLE_FTS3=1                \
            -DSQLITE_ENABLE_COLUMN_METADATA=1     \
            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1       \
            -DSQLITE_SECURE_DELETE=1" 

    make -j1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    install -v -m755 -d         $BUILD_PACK/usr/share/doc/sqlite-3.11.1 
    cp -vR sqlite-doc-3110100/* $BUILD_PACK/usr/share/doc/sqlite-3.11.1
}

