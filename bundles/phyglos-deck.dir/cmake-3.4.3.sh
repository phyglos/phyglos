#!/bin/bash

build_compile()
{
    ./bootstrap             \
	--prefix=/usr       \
        --system-libs       \
        --mandir=/share/man \
        --no-system-jsoncpp \
        --docdir=/share/doc/cmake-3.4.3
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

