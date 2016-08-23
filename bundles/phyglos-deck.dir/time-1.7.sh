#!/bin/bash 

build_compile()
{
    sed -i 's/$(ACLOCAL)//' Makefile.in                                            
    sed -i 's/lu", ptok ((UL) resp->ru.ru_maxrss)/ld", resp->ru.ru_maxrss/' time.c 

    ./configure       \
	--prefix=/usr \
	--infodir=/usr/share/info                            

    make
}

build_pack()
{
    make exec_prefix=$BUILD_PACK/usr info_dir=$BUILD_PACK/usr/share/info install
}
