#!/bin/bash

build_compile()
{
    ./configure                              \
	--prefix=/usr                        \
        --sysconfdir=/etc                    \
        --disable-setuid                     \
        --with-browser=/usr/bin/lynx         \
        --with-vgrind=/usr/bin/vgrind        \
        --with-grap=/usr/bin/grap            \
        --docdir=/usr/share/doc/man-db-2.7.5 

    make
}

build_test_level=3
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
