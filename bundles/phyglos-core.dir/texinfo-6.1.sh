#!/bin/bash

build_compile()
{
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
    make DESTDIR=$BUILD_PACK TEXMF=/usr/share/texmf install-tex
}

install_setup()
{
    bandit_log "Recreating /usr/share/info/dir..."

    pushd /usr/share/info
    rm -v dir
    for f in *; do
	install-info $f dir 2>/dev/null
    done
    popd
}
