#/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
        --disable-static  \
        --disable-gssapi  

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libtirpc.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/libtirpc.so.3.0.0 $BUILD_PACK/usr/lib/libtirpc.so
}
