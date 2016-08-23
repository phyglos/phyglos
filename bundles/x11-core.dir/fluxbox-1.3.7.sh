#!/bin/bash


build_compile()
{
    ./configure --prefix=/usr

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    # Configure startx
    bandit_backup /root/.xinitrc
    echo startfluxbox > /root/.xinitrc

    bandit_mkdir /root/.fluxbox
    cp -v /usr/share/fluxbox/init /root/.fluxbox/init
    cp -v /usr/share/fluxbox/keys /root/.fluxbox/keys

    bandit_pushd /root/.fluxbox
      fluxbox-generate_menu

      # Copy configuration to phy user
      cp  -vR /root/.xinitrc /home/phy/.xinitrc
      chown -v phy:phy /home/phy/.xinitrc

      cp  -vR /root/.fluxbox /home/phy/.fluxbox
      chown -vR phy:phy /home/phy/.fluxbox
    bandit_popd
}
