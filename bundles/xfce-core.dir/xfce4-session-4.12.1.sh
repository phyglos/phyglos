#!/bin/bash

build_compile()
{
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc \
	--disable-legacy-sm

    make
}

build_pack()
{
     make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    update-desktop-database
    update-mime-database /usr/share/mime

    # Configure startx
    bandit_backup /root/.xinitrc
    cat > /root/.xinitrc <<EOF
dbus-launch --exit-with-session startxfce4
EOF

    # Copy configuration to /etc/skel
    cp  -vR /root/.xinitrc /etc/skel/.xinitrc
    
    # Copy configuration to phy user
    cp  -vR /root/.xinitrc /home/phy/.xinitrc
    chown -v phy:phy /home/phy/.xinitrc

}
