#!/bin/bash


build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/xorg-server-1.18.2-add_prime_support-1.patch

    ./configure $PHY_XORG_CONFIG         \
        --enable-install-setuid          \
        --enable-suid-wrapper            \
        --with-xkb-output=/var/lib/xkb   \
        --disable-systemd-logind

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

    bandit_mkdir $BUILD_PACK/etc/X11/xorg.conf.d
}

install_setup()
{
    cat >> /etc/sysconfig/createfiles << "EOF"
# Added by xorg-server installation
/tmp/.ICE-unix dir 1777 root root
/tmp/.X11-unix dir 1777 root root
EOF
}
