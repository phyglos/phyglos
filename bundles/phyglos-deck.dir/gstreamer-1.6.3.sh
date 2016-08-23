#!/bin/bash

build_compile()
{  
    ./configure       \
	--prefix=/usr \
	--with-package-name="GStreamer 1.6.3 BLFS" \
	--with-package-origin="http://www.linuxfromscratch.org/blfs/view/svn/"
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

