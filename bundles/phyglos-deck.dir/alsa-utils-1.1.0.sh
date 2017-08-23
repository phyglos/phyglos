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

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/alsa <<"EOF"
### BEGIN INIT INFO
# Provides:            alsa
# Required-Start:      
# Should-Start:
# Required-Stop:       sendsignals
# Should-Stop:
# Default-Start:       S
# Default-Stop:        0 1 6
# Short-Description:   Restore and store ALSA mixer settings.
# Description:         Restores and stores ALSA mixer settings in the default
#                      location: /var/lib/alsa/asound.state.
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting ALSA...    Restoring volumes..."
      /usr/sbin/alsactl restore
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping ALSA...    Saving volumes..."
      /usr/sbin/alsactl store
      evaluate_retval
      ;;

   *)
      echo "Usage: $0 {start|stop}"
      exit 1
      ;;
esac
EOF

    chmod 754 $BUILD_PACK/etc/init.d/alsa
    for i in S; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/alsa $BUILD_PACK/etc/rc.d/rc$i.d/S60alsa
    done
    for i in 0 1 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/alsa $BUILD_PACK/etc/rc.d/rc$i.d/K35alsa
    done
}

install_setup()
{
    /etc/init.d/alsa start

    # Add user phy to sound group
    gpasswd audio -a phy
}

remove_setup()
{
    /etc/init.d/alsa stop

    # Remove user phy from sound group
    gpasswd audio -d phy
}
