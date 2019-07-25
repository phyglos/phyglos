#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/openssh-7.5p1-openssl-1.1.0-1.patch

    ./configure                                 \
	--prefix=/usr                           \
        --sysconfdir=/etc/ssh                   \
        --with-pam                              \
	--with-md5-passwords                    \
        --with-privsep-path=/var/lib/sshd

    make 
}

build_test_level=1
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    
    bandit_mkdir $BUILD_PACK/usr/bin
    install -v -m755 contrib/ssh-copy-id $BUILD_PACK/usr/bin

    bandit_mkdir $BUILD_PACK/usr/share/man/man1
    install -v -m644 contrib/ssh-copy-id.1 $BUILD_PACK/usr/share/man/man1         

    bandit_mkdir $BUILD_PACK/usr/share/doc/openssh-7.5p1
    install -v -m644 INSTALL LICENCE OVERVIEW README* $BUILD_PACK/usr/share/doc/openssh-7.5p1

    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/sshd <<"EOF"
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
# Provides:            sshd
# Required-Start:      $network
# Should-Start:
# Required-Stop:       sendsignals
# Should-Stop:
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   SSH daemon
# Description:         OpenBSD Secure Shell 
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
    start)
        log_info_msg "Starting SSH Server..."
        start_daemon -f /usr/sbin/sshd
        evaluate_retval
        # Also prevent ssh from being killed by out of memory conditions
        sleep 1
        pid=`cat /run/sshd.pid 2>/dev/null`
        echo "-16" >/proc/${pid}/oom_score_adj
        ;;
    stop)
        log_info_msg "Stopping SSH Server..."
        killproc -p "/run/sshd.pid" /usr/sbin/sshd
        evaluate_retval
        ;;
    reload)
        log_info_msg "Reloading SSH Server..."
        pid=`cat /run/sshd.pid 2>/dev/null`
        if [ -n "${pid}" ]; then
           kill -HUP "${pid}"
        else
           (exit 1)
        fi

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
        echo "Usage: $0 {start|stop|reload|restart|status}"
        exit 1
        ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/sshd
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/sshd $BUILD_PACK/etc/rc.d/rc$i.d/S30sshd
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/sshd $BUILD_PACK/etc/rc.d/rc$i.d/K30sshd
    done

    # Add PAM configuration file
    bandit_mkdir $BUILD_PACK/etc/pam.d
    sed 's@d/login@d/sshd@g' /etc/pam.d/login > $BUILD_PACK/etc/pam.d/sshd
    chmod 644 $BUILD_PACK/etc/pam.d/sshd

    ## Configure SSHd
    cat >> $BUILD_PACK/etc/ssh/sshd_config <<EOF

#---
# Options added by phyglos-security
#---
# Use PAM for ssh login
UsePAM yes

# Disable root login
PermitRootLogin no

# Increase connection interval duration
ClientAliveInterval 300
ClientAliveCountMax 4

EOF
}

install_setup()
{
    # Generate server keys
    yes | ssh-keygen -f /etc/ssh/ssh_host_rsa_key     -N '' -t rsa -b 2048
    yes | ssh-keygen -f /etc/ssh/ssh_host_dsa_key     -N '' -t dsa -b 1024
    yes | ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key   -N '' -t ecdsa -b 521
    yes | ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519 -b 2048

    # Start the service
    /etc/init.d/sshd start
}

remove_setup()
{
    /etc/init.d/sshd stop
}
