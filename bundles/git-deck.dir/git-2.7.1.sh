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
    # Set global user and email
    [[ -z "$GIT_USER_NAME"  ]] || git config --system user.name "$GIT_USER_NAME"
    [[ -z "$GIT_USER_EMAIL" ]] || git config --system user.email "$GIT_USER_EMAIL"

    # Set global editor
    [[ -z "$GIT_EDITOR" ]] || git config --system core.editor "$GIT_EDITOR"

    # Define global alias
    git config --system alias.st status
    git config --system alias.co commit
    git config --system alias.lp log --pretty=oneline
    git config --system alias.bv branch -v
    git config --system alias.rl reflog
    git config --system alias.rh 'reset HEAD --'
}
