#!/bin/bash

build_compile()
{
    ./configure

    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install

     bandit_mkdir $BUILD_PACK/usr/share/doc/alsa-lib-1.1.0/html
     install -v -m644 doc/doxygen/html/*.*      $BUILD_PACK/usr/share/doc/alsa-lib-1.1.0/html
     install -v -d -m755                        $BUILD_PACK/usr/share/doc/alsa-lib-1.1.0/html/search
     install -v -m644 doc/doxygen/html/search/* $BUILD_PACK/usr/share/doc/alsa-lib-1.1.0/html/search
}

