#!/bin/bash

build_compile()
{
    sed -i 's:555:755:g;s:444:644:g' Makedefs.in
    sed -i '/MAN.EXT/s:.gz::g' configure config-scripts/cups-manpages.m4
    sed -i '/LIBGCRYPTCONFIG/d' config-scripts/cups-ssl.m4

    aclocal  -I config-scripts
    autoconf -I config-scripts

    CC=gcc \
    ./configure \
      --libdir=/usr/lib            \
      --disable-systemd            \
      --with-rcdir=/tmp/cupsinit   \
      --with-system-groups=lpadmin \
      --with-docdir=/usr/share/cups/doc-2.1.3
    
    make

}

build_test_level=4
build_test()
{
    make -k check
}

build_pack()
{

    make BUILDROOT=$BUILD_PACK install

    rm -rf $BUILD_PACK/tmp/cupsinit

    bandit_mkdir $BUILD_PACK/usr/share/doc/cups-2.1.3
    ln -svnf ../cups/doc-2.1.3 $BUILD_PACK/usr/share/doc/cups-2.1.3

    bandit_mkdir $BUILD_PACK/etc/cups
    echo "ServerName /var/run/cups/cups.sock" > $BUILD_PACK/etc/cups/client.conf

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/cups <<"EOF"
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
# Provides:            cups
# Required-Start:      $network
# Should-Start:        $remote_fs haldaemon
# Required-Stop:       $network
# Should-Stop:         haldaemon $remote_fs
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   CUPS daemon
# Description:         Common Unix Printing System
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting CUPS..."
      start_daemon /usr/sbin/cupsd
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping CUPS..."
      killproc /usr/sbin/cupsd
      evaluate_retval
      ;;
   reload)
      log_info_msg "Reloading CUPS..."
      killproc /usr/sbin/cupsd -HUP
      evaluate_retval
      ;;
   restart)
      $0 stop
      sleep 1
      $0 start
      ;;
   status)
      statusproc /usr/sbin/cupsd
      ;;
   *)
      echo "Usage: $0 {start|stop|reload|restart|status}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/cups
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/cups $BUILD_PACK/etc/rc.d/rc$i.d/S25cups
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/cups $BUILD_PACK/etc/rc.d/rc$i.d/K00cups
    done
    
    bandit_mkdir $BUILD_PACK/etc/pam.d
    cat > $BUILD_PACK/etc/pam.d/cups << "EOF"
auth    include system-auth
account include system-account
session include system-session
EOF
}

install_setup()
{
    gtk-update-icon-cache

    /etc/init.d/cups start
}

remove_setup()
{
    /etc/init.d/cups stop   
}
