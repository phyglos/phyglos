#!/bin/bash

build_compile()
{
    cd open-vm-tools

    autoreconf -i -Wnone
    
    ./configure                  \
	--prefix=/usr            \
	--sysconfdir=/etc        \
	--without-gtkmm          \
	--without-kernel-modules \
	--without-ssl            \
	--without-xerces         \
	--with-x                 \
	--disable-static

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

    chmod 644 $BUILD_PACK/etc/pam.d/vmtoolsd

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/vmtoolsd <<"EOF"
#!/bin/bash
#
# Copyright (C) 2017 Angel Linares Zapater
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as 
# published by the Free Software Foundation. See the COPYING file.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#
### BEGIN INIT INFO
# Provides:            vmtoolsd
# Required-Start:      
# Should-Start:
# Required-Stop:       sendsignals
# Should-Stop:
# Default-Start:       S
# Default-Stop:        0 1 6
# Short-Description:   vmtools daemon
# Description:         Open VM Tools for VMware guests
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting Open VM Tools..."
      /usr/bin/vmtoolsd --background=/var/run/vmtoolsd.pid
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping Open VM Tools..."
      kill $(cat /var/run/vmtoolsd.pid)
      evaluate_retval
      ;;
   restart)
      $0 stop
      $0 start
      ;;
   *)
      echo "Usage: $0 {start|stop}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/vmtoolsd
    for i in S; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc$i.d/S80vmtoolsd
    done
    for i in 0 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc$i.d/K05vmtoolsd
    done
    
    # Keep clean /sbin
    rm -rd $BUILD_PACK/sbin
}

install_setup()
{
    /etc/init.d/vmtoolsd start
}

remove_setup()
{
    /etc/init.d/vmtoolsd stop
}

