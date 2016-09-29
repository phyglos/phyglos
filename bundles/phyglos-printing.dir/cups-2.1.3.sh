#!/bin/bash

build_compile()
{
    sed -i 's:555:755:g;s:444:644:g' Makedefs.in
    sed -i '/MAN.EXT/s:.gz::g' configure config-scripts/cups-manpages.m4
    sed -i '/LIBGCRYPTCONFIG/d' config-scripts/cups-ssl.m4

    aclocal  -I config-scripts
    autoconf -I config-scripts

    CC=gcc \
    ./configure \
      --libdir=/usr/lib            \
      --disable-systemd            \
      --with-rcdir=/tmp/cupsinit   \
      --with-system-groups=lpadmin \
      --with-docdir=/usr/share/cups/doc-2.1.3
    
    make

}

build_test_level=4
build_test()
{
    make -k check
}

build_pack()
{

    make BUILDROOT=$BUILD_PACK install

    rm -rf $BUILD_PACK/tmp/cupsinit

    bandit_mkdir $BUILD_PACK/usr/share/doc/cups-2.1.3
    ln -svnf ../cups/doc-2.1.3 $BUILD_PACK/usr/share/doc/cups-2.1.3

    bandit_mkdir $BUILD_PACK/etc/cups
    echo "ServerName /var/run/cups/cups.sock" > $BUILD_PACK/etc/cups/client.conf

    bandit_mkdir $BUILD_PACK/etc/pam.d
    cat > $BUILD_PACK/etc/pam.d/cups << "EOF"
auth    include system-auth
account include system-account
session include system-session
EOF
}

install_setup()
{
    gtk-update-icon-cache

    # Start the service
    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-cups
      /etc/init.d/cups start
    popd


}
