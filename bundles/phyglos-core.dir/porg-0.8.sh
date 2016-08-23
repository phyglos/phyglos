#!/bin/bash

build_compile()
{
    ./configure              \
        --prefix=/usr        \
        --sysconfdir=/etc    \
        --localstatedir=/var \
	--disable-grop       \
	--disable-static
    
    make
 
    make install 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 
}
 
install_setup()
{
    # Make porg available in porg database
    make logme
}

