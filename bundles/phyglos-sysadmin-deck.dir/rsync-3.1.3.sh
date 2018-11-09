#!/bin/bash

host_rig()
{
    # Create group and user
    bandit_group_add rsync system
    bandit_user_add rsyncd system rsync "rsync daemon" /srv/rsync /bin/false
}

build_compile()
{
    ./configure       \
	--prefix=/usr \
	--without-included-zlib

    make
}

build_test_level=4
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/rsyncd.conf <<EOF
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
use chroot = yes

[public]
    comment = Default rsync module
    path = /srv/rsync/./public
    motd file = /srv/rsync/public/rsyncd.motd
    read only = yes
    list = yes
    uid = nobody
    gid = nogroup
    max connections=4
EOF

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/rsyncd <<"EOF"
#!/bin/bash
#
# Copyright (C) 2018 Angel Linares Zapater
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
# Provides:            rsyncd
# Required-Start:      $syslog $local_fs $network
# Should-Start:        $remote_fs
# Required-Stop:       $network
# Should-Stop:         $remote_fs
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   rsync daemon
# Description:         Remote incremental synchronization utility
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
    start)
        log_info_msg "Starting rsync daemon..."
        start_daemon /usr/bin/rsync --daemon
        evaluate_retval
        ;;
    stop)
        log_info_msg "Stopping rsync daemon..."
        killproc /usr/bin/rsync
        evaluate_retval
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    status)
        statusproc /usr/sbin/sshd
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/rsyncd
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/rsyncd $BUILD_PACK/etc/rc.d/rc$i.d/S27rsyncd
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/rsyncd $BUILD_PACK/etc/rc.d/rc$i.d/K35rsyncd
    done
}

install_setup()
{
    /etc/init.d/rsyncd start
}

remove_setup()
{
    /etc/init.d/rsyncd stop
}

host_unrig()
{
    # Delete user and group
    bandit_user_delete rsyncd
    bandit_group_delete rsync

    # Delete directories
    rm -rf /var/mail/rsyncd
}

