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
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install 
}
 

