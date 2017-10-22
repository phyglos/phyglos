#!/bin/bash

build_compile()
{
    sed 's|$(PACKAGE)/doc|doc/$(PACKAGE)-$(VERSION)|' \
	-i {,doc/,doc/developer/}Makefile.in
    
    ./configure \
	--prefix=/usr \
	--disable-static

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/gutenprint-5.2.13/api/gutenprint
    cp -v doc/gutenprint/html/*  $BUILD_PACK/usr/share/doc/gutenprint-5.2.13/api/gutenprint

    bandit_mkdir $BUILD_PACK/usr/share/doc/gutenprint-5.2.13/api/gutenprintui2
    cp -v doc/gutenprintui2/html/* $BUILD_PACK/usr/share/doc/gutenprint-5.2.13/api/gutenprintui2

    bandit_mkdir $BUILD_PACK/usr/share/cups/model/gutenprint/5.2
}

install_setup()
{
    # Generate CUPS PPD files
    if [ "${PHY_GENPPD" = "yes" ]; then 
	cups-genppd.5.2
    fi
    
    /etc/init.d/cups restart
}

remove_setup()
{
    # Remove CUPS PPD files
    rm -rvf /usr/share/cups/model/gutenprint/5.2/*

    /etc/init.d/cups restart
}
