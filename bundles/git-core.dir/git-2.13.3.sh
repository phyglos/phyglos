#!/bin/bash

build_compile()
{
    ./configure                         \
	--prefix=/usr                   \
	--with-gitconfig=/etc/gitconfig \
	--with-libpcre                  \
	--without-tcltk

    make
}

build_test_level=4
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    # Set global editor
    [[ -z "$GIT_EDITOR" ]] || git config --system core.editor "$GIT_EDITOR"

    # Define global alias
    git config --system alias.st status
    git config --system alias.co commit
    git config --system alias.ck checkout 
    git config --system alias.lp log --pretty=oneline
}
