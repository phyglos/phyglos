#!/bin/bash

build_compile()
{
    echo "127.0.0.1 localhost $(hostname)" > /etc/hosts

    export BUILD_ZLIB=False
    export BUILD_BZIP2=0

    sh Configure -des                 \
	-Dprefix=/usr                 \
        -Dvendorprefix=/usr           \
        -Dman1dir=/usr/share/man/man1 \
        -Dman3dir=/usr/share/man/man3 \
        -Dpager="/usr/bin/less -isR"  \
        -Duseshrplib

    make

    unset BUILD_ZLIB BUILD_BZIP2
}

build_test_level=2
build_test()
{
    make -k test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
