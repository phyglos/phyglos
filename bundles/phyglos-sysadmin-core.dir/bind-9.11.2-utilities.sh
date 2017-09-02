#!/bin/bash

build_compile()
{
    DISK_MEM_FILL=0       \
    DISK_MEM_TRACKLINES=0 \
    ./configure           \
	--prefix=/usr     \
	--disable-static  \
	--with-openssl
    
    make -C lib/dns
    make -C lib/isc
    make -C lib/bind9
    make -C lib/isccfg
    make -C lib/lwres
    make -C bin/dig
}

build_pack()
{
    make prefix=$BUILD_PACK/usr \
	 -C bin/dig install
}

