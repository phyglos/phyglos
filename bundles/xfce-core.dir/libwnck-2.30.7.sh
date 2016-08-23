#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc \
        --program-suffix=-1

    make GETTEXT_PACKAGE=libwnck-1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK       \
 	 GETTEXT_PACKAGE=libwnck-1 \
	 install
}
