#!/bin/bash

build_compile()
{
    sed -i '/^usbids/ s:usb.ids:hwdata/&:' lsusb.py

    ./configure                     \
	--prefix=/usr               \
        --datadir=/usr/share/hwdata \
	--disable-zlib

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
