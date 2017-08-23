#!/bin/bash

build_compile()
{
    ./configure                        \
	--prefix=/usr                  \
	--sysconfdir=/etc              \
	--localstatedir=/var           \
	--with-boot-install=no         \
	--with-systemdsystemunitdir=no \
	--without-sendmail             \
	--with-pam=yes                 \
	--with-username=crond          \
	--with-groupname=cron
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/fcron <<"EOF"
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
# Provides:            fcron
# Required-Start:      $local_fs 
# Should-Start:        $remote_fs $syslog
# Required-Stop:       $local_fs
# Should-Stop:         $remote_fs $syslog
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   fcron daemon
# Description:         System command scheduler
### END INIT INFO

. /lib/lsb/init-functions

BIN_FILE="/usr/sbin/fcron"

case "$1" in
   start)
      log_info_msg "Starting fcron..."
      start_daemon ${BIN_FILE}
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping fcron..."
      killproc ${BIN_FILE}
      evaluate_retval
      ;;

   restart)
      $0 stop
      sleep 1
      $0 start
      ;;

   status)
      statusproc ${BIN_FILE}
      ;;

   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac
EOF

    chmod 754 $BUILD_PACK/etc/init.d/fcron
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/fcron $BUILD_PACK/etc/rc.d/rc$i.d/S40fcron
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/fcron $BUILD_PACK/etc/rc.d/rc$i.d/K08fcron
    done

    
    # Replace default PAM configuration files
    rm -v $BUILD_PACK/etc/pam.conf

    bandit_mkdir $BUILD_PACK/etc/pam.d
    
    cat > $BUILD_PACK/etc/pam.d/fcron << "EOF"
# always allow root
auth      sufficient  pam_rootok.so

# include system defaults for auth account and session
auth      include     system-auth
account   include     system-account
session   include     system-session

# Always permit for authentication updates
password  required    pam_permit.so
EOF

    cat > $BUILD_PACK/etc/pam.d/fcrontab << "EOF"
# always allow root
auth      sufficient  pam_rootok.so

# include system defaults for auth account and session
auth      include     system-auth
account   include     system-account
session   include     system-session

# Always permit for authentication updates
password  required    pam_permit.so
EOF
}

install_setup()
{
    # Add cron.log to syslog daemon
    cat >> /etc/syslog.conf << "EOF"
cron.* -/var/log/cron.log
EOF
    /etc/rc.d/init.d/sysklogd reload

    /etc/init.d/fcron start
}

remove_setup()
{
    /etc/init.d/fcron stop

    # Remove cron.log from syslog daemon
    sed -i "/cron.log/d" /etc/syslog.conf
    /etc/rc.d/init.d/sysklogd reload
}
