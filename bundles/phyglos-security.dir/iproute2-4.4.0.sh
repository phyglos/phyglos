#!/bin/bash 

build_compile()
{
    # Do not install TIPC as it fails to install if not built
    sed -i -e"/^SUBDIRS/ s/tipc//" Makefile

    # Do not install documentation for arpd
    sed -i /ARPD/d Makefile
    sed -i 's/arpd.8//' man/man8/Makefile
    rm -v doc/arpd.sgml

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK \
	 DOCDIR=/usr/share/doc/iproute2-4.4.0 \
	 install 
}
