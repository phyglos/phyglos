#!/bin/bash 

build_compile()
{
    cd gettext-tools

    EMACS="no"  \
    ./configure \
	--prefix=$BANDIT_BUILDER_DIR \
	--disable-shared

    make -C gnulib-lib
    make -C intl pluralx.c
    make -C src msgfmt
    make -C src msgmerge
    make -C src xgettext
}

build_pack()
{
    mkdir -p $BUILD_PACK$BANDIT_BUILDER_DIR/bin
    cp -v src/{msgfmt,msgmerge,xgettext} $BUILD_PACK$BANDIT_BUILDER_DIR/bin
}
