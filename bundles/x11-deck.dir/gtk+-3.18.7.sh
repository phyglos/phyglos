#!/bin/bash

build_compile()
{
    ./configure                   \
	--prefix=/usr             \
	--sysconfdir=/etc         \
	--enable-broadway-backend \
        --enable-x11-backend      \
        --disable-wayland-backend

    make
}

build_test_level=4
build_test()
{
    glib-compile-schemas /usr/share/glib-2.0/schemas
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/gtk3.sh <<"EOF"
export GTK_THEME="${PHY_GTK_THEME}"
EOF
}

install_setup()
{
    gtk-query-immodules-3.0 --update-cache
    glib-compile-schemas /usr/share/glib-2.0/schemas
}
