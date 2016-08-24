#!/bin/bash

build_compile()
{
    ./configure                         \
	--prefix=/usr                   \
	--with-gitconfig=/etc/gitconfig \
	--with-libpcre                  

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

    ln -s ../libexec/git-core/git-gui $BUILD_PACK/usr/bin
}

install_setup()
{
    # Set global editor
    [[ -z "$GIT_EDITOR" ]] || git config --system core.editor "$GIT_EDITOR"

    # Define global alias
    git config --system alias.st status
    git config --system alias.co commit
    git config --system alias.cm commit -m
    git config --system alias.ck checkout 
    git config --system alias.cb checkout -b
    git config --system alias.bv branch -v
    git config --system alias.lp log --pretty=oneline
    git config --system alias.rh 'reset HEAD --'
}
