#/bin/bash

build_compile()
{
    ./configure                    \
        --prefix=/usr              \
        --disable-static           \
        --enable-threaded-resolver \
        --with-libidn              \
        --without-ssl              \
        --with-gnutls              

    make
}

build_test_level=2
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    rm -rf docs/examples/.deps
    find docs \( -name Makefile\* -o -name \*.1 -o -name \*.3 \)  \
         -exec rm {} \;      

    install -v -d -m755 $BUILD_PACK/usr/share/doc/curl-7.64.0
    cp -v -R docs/*     $BUILD_PACK/usr/share/doc/curl-7.64.0 
}
