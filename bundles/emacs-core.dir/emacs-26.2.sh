#!/bin/bash

build_compile()
{
    ./configure                  \
	--prefix=/usr            \
        --localstatedir=/var     \
        --disable-build-details  \
        --enable-gcc-warnings=no \
        --without-libsystemd     \
        --with-sound=no          \
        --with-x-toolkit=no
    
    make bootstrap
}


build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/emacs.sh <<EOF
export EDITOR=emacs
EOF
}

