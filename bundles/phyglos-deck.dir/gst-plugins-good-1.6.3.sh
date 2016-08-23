#!/bin/bash

build_compile()
{  
    sed -e '/smgradio/ {
             a \  \/* Radionomy Hot40Music shoutcast stream *\/
             a \  g_object_set (src, "location",
             a \      "http://streaming.radionomy.com:80/Hot40Music", NULL);
           }'  \
	-e '/Virgin/,/smgradio/d' \
	-i tests/check/elements/souphttpsrc.c

    ./configure       \
	--prefix=/usr \
	--with-package-name="GStreamer Good Plugins 1.6.3 BLFS" \
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

