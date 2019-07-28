#!/bin/bash

build_compile()
{
    ./configure           \
        --prefix=/usr     \
        --sysconfdir=/etc \
        --with-slang      \
        --enable-utf8     \
        --docdir=/usr/share/doc/nano-4.3

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    install -v -m644 doc/{nano.html,sample.nanorc} $BUILD_PACK/usr/share/doc/nano-4.3

    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/nanorc <<EOF
set autoindent
set const
set fill 72
set historylog
set multibuffer
set regexp
set smooth
set suspend
#set mouse
include /usr/share/nano/*.nanorc
EOF
}
