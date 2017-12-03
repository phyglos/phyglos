#!/bin/bash

build_compile()
{  
    ./configure                \
	--prefix=/usr          \
	--enable-tests         \
	--enable-failing-tests \
	--with-package-name="GStreamer 1.12.2" \
	--with-package-origin="http://www.phyglos.org"
    
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

