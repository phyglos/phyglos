#!/bin/sh

build_compile()
{
    ./configure            \
	--prefix=/usr      \
        --sysconfdir=/etc  

    make
}

build_test_level=2
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    echo "ca-directory=/etc/ssl/certs" >> $BUILD_PACK/etc/wgetrc
}
