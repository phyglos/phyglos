#!/bin/bash

build_compile()
{
    ./autogen.sh
    
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/lib
    ln -sfv libgpm.so.2.1.0 $BUILD_PACK/usr/lib/libgpm.so

    bandit_mkdir $BUILD_PACK/etc/sysconfig
    install -v -m644 conf/gpm-root.conf $BUILD_PACK/etc  
    cat > $BUILD_PACK/etc/sysconfig/mouse << EOF
MDEVICE=$PHY_GPM_DEVICE
PROTOCOL=$PHY_GPM_PROTOCOL
GPMOPTS=""
EOF

    bandit_mkdir $BUILD_PACK/usr/share/doc/gpm-1.20.7
    install -v -m755 -d $BUILD_PACK/usr/share/doc/gpm-1.20.7/support
    install -v -m644 doc/support/* $BUILD_PACK/usr/share/doc/gpm-1.20.7/support
    install -v -m644 doc/{FAQ,HACK_GPM,README*} $BUILD_PACK/usr/share/doc/gpm-1.20.7
}

install_setup()
{
    install-info --dir-file=/usr/share/info/dir /usr/share/info/gpm.info
    
    pushd /opt/blfs-bootscripts
    make install-gpm
    /etc/init.d/gpm start
    popd
}
