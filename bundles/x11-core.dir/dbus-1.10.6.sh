#!/bin/bash

build_compile()
{
    ./configure                        \
	--prefix=/usr                  \
        --sysconfdir=/etc              \
        --localstatedir=/var           \
	--disable-doxygen-docs         \
        --disable-xml-docs             \
        --disable-static               \
        --disable-systemd              \
        --without-systemdsystemunitdir \
        --with-console-auth-dir=/run/console/ \
        --docdir=/usr/share/doc/dbus-1.10.6   \
	--with-dbus-user=dbusd

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chown -v root:dbus $BUILD_PACK/usr/libexec/dbus-daemon-launch-helper
    chmod -v 4750      $BUILD_PACK/usr/libexec/dbus-daemon-launch-helper

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/dbus <<"EOF"
#!/bin/bash
#
# Copyright (C) 2017 Angel Linares Zapater
# Based on the work of the Linux from Scratch project
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as 
# published by the Free Software Foundation. See the COPYING file.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#
### BEGIN INIT INFO
# Provides:            dbus
# Required-Start:      cleanfs
# Should-Start:        $remote_fs
# Required-Stop:       sendsignals
# Should-Stop:
# Default-Start:       2 3 4 5
# Default-Stop:        0 1 6
# Short-Description:   D-Bus daemon
# Description:         D-Bus message bus system
### END INIT INFO

. /lib/lsb/init-functions

pidfile=/run/dbus/pid
socket=/run/dbus/system_bus_socket

case "$1" in
   start)
      log_info_msg "Starting the D-Bus system..."
      mkdir -p /run/dbus
      /usr/bin/dbus-uuidgen --ensure
      start_daemon /usr/bin/dbus-daemon --system
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping the D-Bus system..."
      killproc /usr/bin/dbus-daemon
      evaluate_retval
      rm -f $socket $pidfile
      ;;
   restart)
      $0 stop
      sleep 1
      $0 start
      ;;
   status)
      statusproc /usr/bin/dbus-daemon
      ;;
   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/dbus
    for i in 2 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/dbus $BUILD_PACK/etc/rc.d/rc$i.d/S29dbus
    done
    for i in 0 1 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/dbus $BUILD_PACK/etc/rc.d/rc$i.d/K30dbus
    done
}

install_setup()
{
    # Create the daemon group and user
    groupadd -g 18 dbus
    useradd -c "D-Bus daemom"   \
	    -d /var/lib/dbus    \
	    -u 18 -g dbus       \
	    -s /bin/false       \
	    dbusd

    # Start the service
    /etc/init.d/dbus start
}

remove_setup()
{
    # Stop the service
    /etc/init.d/dbus stop

    # Remove the daemon group and user
    userdel dbusd
    groupdel dbus
}
