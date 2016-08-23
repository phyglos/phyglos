#!/bin/bash 


build_compile()
{
    make
}

build_pack()
{
    make install \
	prefix=$BUILD_PACK/usr \
	MANDIR=$BUILD_PACK/usr/share/man/man1
}
