#!/bin/bash

KO_build_compile()
{
    ./configure               \
	--prefix=/usr         \
        --localstatedir=/var  \
	--with-x-toolkit=${EMACS_X_TOOLKIT}
	
    make bootstrap
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    chown -R root:root $BUILD_PACK/usr/share/emacs/24.5

    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/emacs.sh <<EOF
export EDITOR=emacs
EOF
}

install_setup()
{
    update-desktop-database /usr/share/applications
    
    gtk-update-icon-cache -t -f --include-image-data /usr/share/icons/hicolor
}
