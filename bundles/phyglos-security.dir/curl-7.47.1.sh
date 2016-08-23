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

    install -v -d -m755 $BUILD_PACK/usr/share/doc/curl-7.47.1
    cp -v -R docs/*     $BUILD_PACK/usr/share/doc/curl-7.47.1 
}

install_verify()
{
    bandit_log "Verifying cURL..."

    echo
    bandit_msg "Downloading file..."
    curl --trace-ascii debugdump.txt http://www.example.com/

    echo
    bandit_msg "Downloading file..."
    curl --trace-ascii d.txt --trace-time http://example.com/
}
