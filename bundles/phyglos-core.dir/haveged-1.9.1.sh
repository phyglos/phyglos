#!/bin/sh

build_compile()
{
    ./configure            \
	--prefix=/usr

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/haveged-1.9.1
    cp README $BUILD_PACK/usr/share/doc/haveged-1.9.1
}

install_setup()
{
    pushd /opt/blfs-bootscripts
      make install-haveged
      /etc/init.d/haveged start
    popd
}
