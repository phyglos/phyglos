#!/bin/bash


build_compile()
{
    sed -i '/v0/{n;s/new:/new:kb=^?:/}' termcap
    echo -e '\tkbs=\\177,' >> terminfo

    TERMINFO=/usr/share/terminfo  \
    ./configure $XORG_CONFIG      \
        --with-app-defaults=/etc/X11/app-defaults

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	 prefix=/usr         \
	 install

    make DESTDIR=$BUILD_PACK install-ti

    bandit_mkdir $BUILD_PACK/etc/X11/app-defaults
    cat >> $BUILD_PACK/etc/X11/app-defaults/XTerm << "EOF"
*VT100*locale: true
*VT100*faceName: Monospace
*VT100*faceSize: 10
*backarrowKeyIsErase: true
*ptyInitialErase: true
EOF
}

