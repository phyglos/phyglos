#!/bin/bash

build_compile()
{
    ./configure \
	--prefix=/usr      \
	--sbindir=/sbin    \
	--disable-nftables \
	--enable-libipq    \
	--with-xtlibdir=/lib/xtables
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -sfv ../../sbin/xtables-multi $BUILD_PACK/usr/bin/iptables-xml

    bandit_mkdir $BUILD_PACK/lib
    for file in ip4tc ip6tc ipq iptc xtables
    do
	mv -v $BUILD_PACK/usr/lib/lib${file}.so.* $BUILD_PACK/lib
	ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/lib${file}.so) $BUILD_PACK/usr/lib/lib${file}.so
    done   
}

install_setup()
{
    pushd /opt/blfs-bootscripts
      make install-iptables
      /etc/init.d/iptables start
    popd
}
