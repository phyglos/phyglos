#!/bin/bash

build_compile()
{
    export GMAKE_NOWARN=true
    make \
	INS_BASE=/usr  \
	DEFINSUSR=root \
	DEFINSGRP=root
}

build_pack()
{
    export GMAKE_NOWARN=true
    make \
	INS_BASE=$BUILD_PACK/usr  \
	DEFINSUSR=root \
	DEFINSGRP=root \
	install

    bandit_mkdir $BUILD_PACK/usr/share/doc/cdrtools-3.02a07
    cp -v README* ABOUT doc/*.ps $BUILD_PACK/usr/share/doc/cdrtools-3.02a07
}

