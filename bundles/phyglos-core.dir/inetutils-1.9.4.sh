#!/bin/bash

build_compile()
{
    ./configure              \
	--prefix=/usr        \
        --localstatedir=/var \
        --disable-logger     \
        --disable-whois      \
        --disable-rcp        \
        --disable-rexec      \
        --disable-rlogin     \
        --disable-rsh        \
        --disable-servers
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

    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/{hostname,ping,ping6,traceroute} $BUILD_PACK/bin

    bandit_mkdir $BUILD_PACK/sbin
    mv -v $BUILD_PACK/usr/bin/ifconfig $BUILD_PACK/sbin
}
