#!/bin/bash

build_compile()
{
    sed "/speex_preprocess.h/i#include <stdint.h>" \
	-i speex/pcm_speex.c

    ./configure

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

