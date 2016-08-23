#!/bin/bash 

build_compile()
{
    PKG_CONFIG=""                      \
    ./configure                        \
	--prefix=$BANDIT_BUILDER_DIR      \
        --without-python               \
        --disable-makeinstall-chown    \
        --without-systemdsystemunitdir \

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
