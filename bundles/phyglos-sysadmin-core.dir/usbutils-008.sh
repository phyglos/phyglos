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

    install -dm755 $BUILD_PACK/usr/share/hwdata/
}

install_setup()
{
    bandit_msg "Downloading usb.ids..."
    wget http://www.linux-usb.org/usb.ids -O /usr/share/hwdata/usb.ids
}
