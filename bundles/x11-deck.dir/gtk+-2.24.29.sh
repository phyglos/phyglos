#!/bin/bash

build_compile()
{
    sed -e 's#l \(gtk-.*\).sgml#& -o \1#' \
	-i docs/{faq,tutorial}/Makefile.in   

    ./configure          \
	--prefix=/usr    \
	--sysconfdir=/etc

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    gtk-query-immodules-2.0 --update-cache
}

