#!/bin/bash

build_compile()
{
    ./configure       \
	--prefix=/usr \
        --docdir=/usr/share/doc/acpid-2.0.28 

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc/acpid/events
    chmod -R 755 $BUILD_PACK/etc/acpid/events
    
    bandit_mkdir $BUILD_PACK/usr/share/doc/acpid-2.0.28
    cp -r samples $BUILD_PACK/usr/share/doc/acpid-2.0.28

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/acpid <<"EOF"
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
# Provides:            acpid
# Required-Start:      $remote_fs $syslog
# Required-Stop:       $remote_fs $syslog
# Default-Start:       2 3 4 5
# Default-Stop:        0 1 6
# Short-Description:   ACPI daemon
# Description:         Advanced Configuration and Power Interface
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting ACPI event daemon..."
      start_daemon /usr/sbin/acpid
      sleep 1
      pidofproc -p "/run/acpid.pid" > /dev/null
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping ACPI event daemon..."
      killproc -p "/run/acpid.pid" /usr/sbin/acpid
      evaluate_retval
      ;;

   restart)
      $0 stop
      sleep 1
      $0 start
      ;;

   status)
      statusproc /usr/sbin/acpid
      ;;

   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac
EOF

    chmod 754 $BUILD_PACK/etc/init.d/acpid
    for i in 2 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/acpid $BUILD_PACK/etc/rc.d/rc$i.d/S32acpid
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/acpid $BUILD_PACK/etc/rc.d/rc$i.d/K18acpid
    done

}

install_setup()
{
    /etc/init.d/acpid start
}

remove_setup()
{
    /etc/init.d/acpid stop
}

