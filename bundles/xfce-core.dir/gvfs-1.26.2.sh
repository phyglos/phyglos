#!/bin/bash

build_compile()
{
    ./configure            \
	--prefix=/usr      \
	--sysconfdir=/etc  \
	--disable-documentation \
	--disable-afp      \
	--disable-nfs      \
	--disable-gcr      \
	--disable-gdu      \
	--disable-goa      \
	--disable-google   \
	--disable-samba    \
	--disable-udisks2  \
	--disable-gphoto2
    
    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

build_setup()
{
    glib-compile-schemas /usr/share/glib-2.0/schemas
}
