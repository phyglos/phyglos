#!/bin/bash

build_compile()
{
    mkdir build
    cd build

    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ..
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    pushd ../doc 
    for man in man/man?/* ; do
	bandit_mkdir $BUILD_PACK/usr/share/$man
	install -v -D -m 644 $man $BUILD_PACK/usr/share/$man
    done       
    popd
}
