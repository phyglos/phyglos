#!/bin/bash

build_compile()
{
    ./configure		      \
	--prefix=/usr	      \
	--with-internal-glib  \
	--disable-host-tool   \
	--docdir=/usr/share/doc/pkg-config-0.29

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
