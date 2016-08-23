#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/bash-4.3.30-upstream_fixes-3.patch

    ./configure                             \
	--prefix=/usr                       \
        --bindir=/bin                       \
        --docdir=/usr/share/doc/bash-4.3.30 \
        --without-bash-malloc               \
        --with-installed-readline

    make 
}

build_test_level=1
build_test_level()
{
    chown -Rv nobody .
    su nobody -s /bin/bash -c "PATH=$PATH make tests"
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
