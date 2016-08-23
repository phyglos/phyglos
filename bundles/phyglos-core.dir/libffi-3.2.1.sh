#!/bin/bash

build_compile()
{
    sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' \
	-i include/Makefile.in 

    sed -e '/^includedir/ s/=.*$/=@includedir@/' \
	-e 's/^Cflags: -I${includedir}/Cflags:/' \
	-i libffi.pc.in   

    ./configure       \
	--prefix=/usr \
	--disable-static 

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
