#!/bin/bash

build_compile()
{
    sed -i 's:\\\${:\\\$\\{:' intltool-update.in

    ./configure --prefix=/usr

    make
}

build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    install -v -Dm644 doc/I18N-HOWTO $BUILD_PACK/usr/share/doc/intltool-0.51.0/I18N-HOWTO
}
