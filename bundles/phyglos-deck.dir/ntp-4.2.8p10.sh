#!/bin/bash

build_compile()
{
    # Fix update-leap command
    sed -e "s/https/http/"              \
        -e 's/"(\\S+)"/"?([^\\s"]+)"?/' \
        -i scripts/update-leap/update-leap.in
    
    CFLAGS="-O2 -g -fPIC"            \
    ./configure                      \
	--prefix=/usr                \
	--bindir=/usr/sbin           \
	--sysconfdir=/etc            \
	--enable-linuxcaps           \
	--with-lineeditlibs=readline \
	--docdir=/usr/share/doc/ntp-4.2.8p10
    
    make
}

build_test_level=4
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/var/lib
    install -v -o ntpd -g ntp -d $BUILD_PACK/var/lib/ntp

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/ntpd <<"EOF"
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
# Provides:            ntpd
# Required-Start:      $time $network
# Should-Start:        $remote_fs
# Required-Stop:       $network
# Should-Stop:         $remote_fs
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   Network Time Protocol daemon
# Description:         NTP syncronizes time with time servers worldwide
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting Network Time Protocol..."
      start_daemon /usr/sbin/ntpd -g -u ntpd:ntp
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping Network Time Protocol..."
      killproc /usr/sbin/ntpd
      evaluate_retval
      ;;

   restart)
      $0 stop
      sleep 1
      $0 start
      ;;

   status)
      statusproc /usr/sbin/ntpd
      ;;

   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/ntpd
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/ntpd $BUILD_PACK/etc/rc.d/rc$i.d/S26ntpd
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/ntpd $BUILD_PACK/etc/rc.d/rc$i.d/K46ntpd
    done

    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/ntp.conf << "EOF"
# Asia
server 0.asia.pool.ntp.org

# Australia
server 0.oceania.pool.ntp.org

# Europe
server 0.europe.pool.ntp.org

# North America
server 0.north-america.pool.ntp.org

# South America
server 2.south-america.pool.ntp.org

driftfile /var/lib/ntp/ntp.drift
pidfile   /var/run/ntpd.pid

leapfile  /etc/ntp.leapseconds

# Security session
restrict    default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery

restrict 127.0.0.1
restrict ::1
EOF
}

install_setup()
{
    /etc/init.d/ntpd start
}

remove_setup()
{
    /etc/init.d/ntpd stop
}
