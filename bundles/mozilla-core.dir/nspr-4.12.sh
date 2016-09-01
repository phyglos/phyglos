#!/bin/bash

build_compile()
{
    cd nspr                                                     
    sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in 
    sed -i 's#$(LIBRARY) ##' config/rules.mk                    

    ./configure         \
	--prefix=/usr   \
        --with-mozilla  \
        --with-pthreads \
        $([ $BANDIT_TARGET_ARCH = x86_64 ] && echo --enable-64bit) 

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

