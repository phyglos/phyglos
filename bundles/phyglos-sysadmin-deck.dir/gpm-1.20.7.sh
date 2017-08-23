#!/bin/bash

build_compile()
{
    ./autogen.sh
    
    ./configure           \
	--prefix=/usr     \
	--sysconfdir=/etc
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/info
    install-info --dir-file=$BUILD_PACK/usr/share/info/dir $BUILD_PACK/usr/share/info/gpm.info

    bandit_mkdir $BUILD_PACK/usr/lib
    ln -sfv libgpm.so.2.1.0 $BUILD_PACK/usr/lib/libgpm.so

    bandit_mkdir $BUILD_PACK/usr/share/doc/gpm-1.20.7
    install -v -m755 -d $BUILD_PACK/usr/share/doc/gpm-1.20.7/support
    install -v -m644 doc/support/* $BUILD_PACK/usr/share/doc/gpm-1.20.7/support
    install -v -m644 doc/{FAQ,HACK_GPM,README*} $BUILD_PACK/usr/share/doc/gpm-1.20.7

    bandit_mkdir $BUILD_PACK/etc
    install -v -m644 conf/gpm-root.conf $BUILD_PACK/etc  

    bandit_mkdir $BUILD_PACK/etc/sysconfig
    cat > $BUILD_PACK/etc/sysconfig/mouse << EOF
MDEVICE=${PHY_GPM_DEVICE}
PROTOCOL=${PHY_GPM_PROTOCOL}
GPMOPTS=${PHY_GPM_OPTIONS}
EOF

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/gpm <<"EOF"
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
# Provides:            gpm
# Required-Start:      $network $local_fs
# Should-Start:
# Required-Stop:       $local_fs $network
# Should-Stop:
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   GPM daemom
# Description:         General Purpose Mouse for Linux console
### END INIT INFO

. /lib/lsb/init-functions

pidfile="/run/gpm.pid"

[ -f /etc/sysconfig/mouse ] && source /etc/sysconfig/mouse

case "${1}" in
   start)
      log_info_msg "Starting GPM console mouse service..."
      if [ "${MDEVICE}" = "" -o "${PROTOCOL}" = "" ]; then
         log_info_msg2 "invalid configuration"
         log_failure_msg
         exit 2
      fi
      start_daemon /usr/sbin/gpm -m "${MDEVICE}" -t "${PROTOCOL}" ${GPMOPTS}
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping GPM console mouse service..."
      killproc /usr/sbin/gpm
      evaluate_retval
      ;;
   force-reload)
      # gpm does not honor SIGHUP, restart if running
      kill -0 `pidofproc -p "${pidfile}" /usr/sbin/gpm` 2>/dev/null
      if [ "${?}" = "0" ]; then
         ${0} restart
      else
         log_info_msg "Force reloading GPM console mouse service..."
         log_info_msg2 "not running"
         log_failure_msg
      fi
      ;;
   restart)
      ${0} stop
      sleep 1
      ${0} start
      ;;
   status)
      statusproc /usr/sbin/gpm
      ;;
   *)
      echo "Usage: ${0} {start|stop|force-reload|restart|status}"
      exit 1
      ;;
esac
exit 0
EOF
    chmod 754 $BUILD_PACK/etc/init.d/gpm
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/gpm $BUILD_PACK/etc/rc.d/rc$i.d/S70gpm
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/gpm $BUILD_PACK/etc/rc.d/rc$i.d/K1ogpm
    done  
}

install_setup()
{
    /etc/init.d/gpm start
}

remove_setup()
{
    /etc/init.d/gpm stop
}

