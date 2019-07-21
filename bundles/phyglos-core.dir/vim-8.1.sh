#!/bin/bash

build_compile()
{
    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

    ./configure             \
        --prefix=/usr       \
        --with-features=huge

    make
}

build_test_level=3
build_test()
{
    LANG=en_US.UTF-8 \
    make -j1 test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -sv vim $BUILD_PACK/usr/bin/vi
    for L in $BUILD_PACK/usr/share/man/{,*/}man1/vim.1; do
	ln -sv vim.1 $(dirname $L)/vi.1
    done

    bandit_mkdir $BUILD_PACK/usr/share/doc
    ln -sv ../vim/vim74/doc $BUILD_PACK/usr/share/doc/vim-8.1

    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/vimrc << EOF
" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
colorscheme paco
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif
syntax on
EOF
}
