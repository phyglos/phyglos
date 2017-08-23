#!/bin/sh

build_compile()
{
    ./configure            \
	--prefix=/usr

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/haveged-1.9.1
    cp README $BUILD_PACK/usr/share/doc/haveged-1.9.1

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/haveged <<"EOF"
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
# Provides:            haveged
# Required-Start:      
# Should-Start:        
# Required-Stop:       
# Should-Stop:         
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   haveged daemon
# Description:         Provide increased entropy to /dev/random
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting haveged..."
      start_daemon /usr/sbin/haveged
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping haveged..."
      killproc /usr/sbin/haveged
      evaluate_retval
      ;;
 
   status)
      statusproc /usr/sbin/haveged
      ;;

   *)
      echo "Usage: $0 {start|stop|status}"
      exit 1
      ;;
esac
EOF

    chmod 754 $BUILD_PACK/etc/init.d/haveged
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/haveged $BUILD_PACK/etc/rc.d/rc$i.d/S21haveged
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/haveged $BUILD_PACK/etc/rc.d/rc$i.d/K90haveged
    done
}

install_setup()
{
    /etc/init.d/haveged start
}

remove_setup()
{
    /etc/init.d/haveged stop
}
