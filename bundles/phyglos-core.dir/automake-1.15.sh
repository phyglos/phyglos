#!/bin/bash

build_compile()
{
    sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in

    ./configure        \
	--prefix=/usr  \
	--docdir=/usr/share/doc/automake-1.15

    make 
}

build_test_level=3
build_test()
{
    sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
    make -j4 check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
