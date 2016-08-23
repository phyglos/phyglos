#!/bin/bash


build_compile()
{
    sed -e "s/pthread-stubs//" -i configure

    ./configure $PHY_XORG_CONFIG \
        --enable-xinput    \
	--without-doxygen  \
        --docdir='${datadir}'/doc/libxcb-1.11

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
}
