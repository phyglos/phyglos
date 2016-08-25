#!/bin/bash

build_compile()
{
    make
}

build_pack()
{
    make prefix=$BUILD_PACK/usr install 

    bandit_mkdir $BUILD_PACK/bin
    mv $BUILD_PACK/usr/bin/traceroute $BUILD_PACK/bin 
    ln -sv -f traceroute $BUILD_PACK/bin/traceroute6 

    bandit_mkdir $BUILD_PACK/usr/share/man/man8/
    ln -sv -f traceroute.8 $BUILD_PACK/usr/share/man/man8/traceroute6.8
}

install_setup()
{
    # Remove inetutils man page
    rm -fv /usr/share/man/man1/traceroute.1
}
