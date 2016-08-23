#!/bin/bash

build_compile()
{
    sed -i "s|n/a|unavailable|" lsb_release

    ./help2man -N \
	--include ./lsb_release.examples \
        --alt_version_key=program_version ./lsb_release \
	> lsb_release.1
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/share/man/man1
    install -v -m 644 lsb_release.1 $BUILD_PACK/usr/share/man/man1/lsb_release.1 

    bandit_mkdir $BUILD_PACK/usr/bin
    install -v -m 755 lsb_release   $BUILD_PACK/usr/bin/lsb_release
}


