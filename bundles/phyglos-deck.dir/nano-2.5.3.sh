#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
        --sysconfdir=/etc \
	--with-slang      \
        --enable-utf8 

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc
    install -v -m644 doc/nanorc.sample $BUILD_PACK/etc 

    bandit_mkdir $BUILD_PACK/usr/share/doc
    install -v -m755 -d $BUILD_PACK/usr/share/doc/nano-2.5.3
    install -v -m644 doc/{,man/,texinfo/}*.html $BUILD_PACK/usr/share/doc/nano-2.5.3

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
