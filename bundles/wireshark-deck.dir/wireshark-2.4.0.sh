#!/bin/bash

case ${PHY_WIRESHARK_GRAPH} in
    gtk2)
	OPTIONS_GRAPH="--with-gtk=2 --with-qt=no"
    ;;
    gtk3)
	OPTIONS_GRAPH="--with-gtk=3 --with-qt=no"
    ;;
    qt5)
	OPTIONS_GRAPH="--with-qt=5"
    ;;
esac
    
build_compile()
{
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc \
	${OPTIONS_GRAPH}  \
	--without-lua 
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chown -v root:wireshark $BUILD_PACK/usr/bin/{tshark,dumpcap}
    chmod -v 6550 $BUILD_PACK/usr/bin/{tshark,dumpcap}
    
    bandit_mkdir $BUILD_PACK/usr/share/doc/wireshark-2.4.0
    cp -v README{,.linux} doc/README.* doc/*.{pod,txt} $BUILD_PACK/usr/share/doc/wireshark-2.4.0

    pushd $BUILD_PACK/usr/share/doc/wireshark-2.4.0
	for FILENAME in ../../wireshark/*.html; do
	    ln -s -v -f $FILENAME .
	done 
    popd
    unset FILENAME
}

install_setup()
{
    gtk-update-icon-cache
}

remove_setup()
{
    gtk-update-icon-cache
}
