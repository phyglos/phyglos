#!/bin/bash 

build_compile()
{
    sed -i /ARPD/d Makefile
    sed -i 's/arpd.8//' man/man8/Makefile
    rm -v doc/arpd.sgml

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK DOCDIR=/usr/share/doc/iproute2-4.4.0 install
}
