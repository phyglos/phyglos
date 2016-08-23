#!/bin/bash

build_compile()
{
    make -f unix/Makefile generic
}

build_pack()
{
    make -f unix/Makefile install \
	prefix=$BUILD_PACK/usr \
	MANDIR=$BUILD_PACK/usr/share/man/man1
}
