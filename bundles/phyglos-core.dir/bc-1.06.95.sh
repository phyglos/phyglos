#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/bc-1.06.95-memory_leak-1.patch

    ./configure                 \
	--prefix=/usr           \
        --with-readline         \
        --mandir=/usr/share/man \
        --infodir=/usr/share/info

    make
}

build_test_level=3
build_test()
{
    echo "quit" | ./bc/bc -l Test/checklib.b
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
