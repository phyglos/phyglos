#!/bin/bash


build_compile()
{
    ./configure --prefix=/usr

    makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi &&
    makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    install -v -dm755 $BUILD_PACK/usr/share/doc/dejagnu-1.5.3
    install -v -m644  doc/dejagnu.{html,txt}  $BUILD_PACK/usr/share/doc/dejagnu-1.5.3
}
