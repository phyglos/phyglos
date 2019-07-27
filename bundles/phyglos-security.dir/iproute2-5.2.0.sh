#!/bin/bash 

build_compile()
{
    # Do not install arpd, which dependens of Berkeley BD
    sed -i /ARPD/d Makefile
    rm -fv man/man8/arpd.8

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	 DOCDIR=/usr/share/doc/iproute2-5.2..0 \
	 install 
}
