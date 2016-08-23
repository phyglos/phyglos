#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--disable-static

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install

     bandit_mkdir $BUILD_PACK/usr/share/doc/startup-notification-0.12
     install -v -m644 -D doc/startup-notification.txt \
	 $BUILD_PACK/usr/share/doc/startup-notification-0.12/startup-notification.txt
}
