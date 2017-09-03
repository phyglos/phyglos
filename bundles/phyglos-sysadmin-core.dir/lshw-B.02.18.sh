#/bin/bash

build_compile()
{
    make
}

build_pack()
{
    make -j1 DESTDIR=$BUILD_PACK \
	 install all

    # Remove hwdata files from build pack.
    # They are update later.
    rm -vrf $BUILD_PACK/usr/share/lshw   
}

