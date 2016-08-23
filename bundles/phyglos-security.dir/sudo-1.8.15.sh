#!/bin/bash

build_compile()
{
    ./configure                    \
	--prefix=/usr              \
        --libexecdir=/usr/lib      \
        --with-secure-path         \
        --with-all-insults         \
        --with-env-editor          \
        --with-passprompt="[sudo] password for %p: " \
	--without-pam              \
        --docdir=/usr/share/doc/sudo-1.8.15  

    make
}

build_test_level=1
build_test()
{
    env LC_ALL=C make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -sfv libsudo_util.so.0.0.0 $BUILD_PACK/usr/lib/sudo/libsudo_util.so.0
}
