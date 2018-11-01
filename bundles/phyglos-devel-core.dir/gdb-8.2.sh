#!/bin/bash

build_compile()
{
    ./configure                \
	--prefix=/usr          \
	--sysconfdir=/etc      \
	--with-system-readline \
	--without-guile

    make
}

build_test_level=2
build_test()
{
    pushd gdb/testsuite
	make site.exp
	echo "set gdb_test_timeout 120" >> site.exp
	runtest TRANSCRIPT=y
    popd
}

build_pack()
{
    make -C gdb DESTDIR=$BUILD_PACK install
}

