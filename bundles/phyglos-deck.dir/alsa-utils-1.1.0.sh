#!/bin/bash

build_compile()
{
    ./configure            \
	--disable-alsaconf \
	--disable-bat      \
	--disable-xmlto    \
	--with-curses=ncursesw
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/var/lib/alsa
    touch $BUILD_PACK/var/lib/alsa/asound.state
}

install_setup()
{
    # Start the service
    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-alsa
      /etc/init.d/alsa start
    popd

    alsactl -L store

    # Add user phy to sound group
    usermod -a -G audio phy
}
