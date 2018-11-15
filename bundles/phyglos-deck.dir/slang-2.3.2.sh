#!/bin/bash

build_compile()
{
    ./configure             \
	--prefix=/usr       \
        --sysconfdir=/etc   \
        --with-readline=gnu \
	--without-x

    make -j1
}

build_test_level=4
build_test()
{
    make -j1 check
}

build_pack()
{
    make -j1 DESTDIR=$BUILD_PACK install             \
	SLSH_DOC_DIR=/usr/share/doc/slang-2.3.2/slsh \
	install_doc_dir=/usr/share/doc/slang-2.3.2

    chmod -v 755 $BUILD_PACK/usr/lib/libslang.so.2.3.2
    chmod -v 755 $BUILD_PACK/usr/lib/slang/v2/modules/*.so
}
