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

    # Install man pages package
    tar -xf $BUILD_SOURCES/git-manpages-2.13.3.tar.xz -C $BUILD_PACK/usr/share/man \
	--no-same-owner --no-overwrite-dir
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
