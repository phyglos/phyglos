#!/bin/bah

build_compile()
{
    sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in

    ./configure --prefix=/usr

    make 
}

build_test_level=3
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
