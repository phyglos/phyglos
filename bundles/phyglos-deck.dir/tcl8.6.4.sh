#!/bin/bash

build_compile()
{
    tar -xf $BUILD_SOURCES/tcl8.6.4-html.tar.gz --strip-components=1

    export SRCDIR=`pwd`

    cd unix
    ./configure                 \
	--prefix=/usr           \
        --mandir=/usr/share/man \
        $([ $BANDIT_TARGET_ARCH = x86_64 ] && echo --enable-64bit)

    make

    sed -e "s#$SRCDIR/unix#/usr/lib#" \
	-e "s#$SRCDIR#/usr/include#"  \
	-i tclConfig.sh               

    sed -e "s#$SRCDIR/unix/pkgs/tdbc1.0.3#/usr/lib/tdbc1.0.3#" \
	-e "s#$SRCDIR/pkgs/tdbc1.0.3/generic#/usr/include#"    \
	-e "s#$SRCDIR/pkgs/tdbc1.0.3/library#/usr/lib/tcl8.6#" \
	-e "s#$SRCDIR/pkgs/tdbc1.0.3#/usr/include#"            \
	-i pkgs/tdbc1.0.3/tdbcConfig.sh                       

    sed -e "s#$SRCDIR/unix/pkgs/itcl4.0.3#/usr/lib/itcl4.0.3#" \
	-e "s#$SRCDIR/pkgs/itcl4.0.3/generic#/usr/include#"    \
	-e "s#$SRCDIR/pkgs/itcl4.0.3#/usr/include#"            \
	-i pkgs/itcl4.0.3/itclConfig.sh                       

    unset SRCDIR
}

build_test_level=4
build_test()
{
    TZ=UTC make test   
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    make DESTDIR=$BUILD_PACK install-private-headers

    chmod -v u+w $BUILD_PACK/usr/lib/libtcl8.6.so

    bandit_mkdir $BUILD_PACK/usr/bin
    ln -sv tclsh8.6 $BUILD_PACK/usr/bin/tclsh

    bandit_mkdir $BUILD_PACK/usr/share/doc/tcl-8.6.4
    cp -vr ../html/* $BUILD_PACK/usr/share/doc/tcl-8.6.4
}
