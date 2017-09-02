#!/bin/bash

build_compile()
{
    make
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/sbin
    install -v -m 755 vsftpd $BUILD_PACK/usr/sbin/vsftpd

    bandit_mkdir $BUILD_PACK/usr/share/man/man5
    install -v -m 644 vsftpd.conf.5 $BUILD_PACK/usr/share/man/man5
    bandit_mkdir $BUILD_PACK/usr/share/man/man8
    install -v -m 644 vsftpd.8 $BUILD_PACK/usr/share/man/man8

    # Create empty chroot directory
    bandit_mkdir $BUILD_PACK/srv/vsftpd/empty

    # Create configuration file
    bandit_mkdir $BUILD_PACK/etc
    install -v -m 644 vsftpd.conf $BUILD_PACK/etc

    # Reconfigure default options
    sed -e "s|#nopriv_user=ftpsecure|nopriv_user=vsftpd|"  \
	-e "s|anonymous_enable=YES|anonymous_enable=NO|"   \
	-e "s|#local_enable=YES|local_enable=YES|"         \
	-i $BUILD_PACK/etc/vsftpd.conf

    # Add more default options
    cat >> $BUILD_PACK/etc/vsftpd.conf <<EOF
#
# phyglos: Run in background after launch
background=YES
# phyglos: Default empty directory
secure_chroot_dir=/srv/vsftpd/empty
# phyglos: Configure PAM sessions
session_support=YES
pam_service_name=vsftpd
EOF

    # Configure PAM for virtual users
    bandit_mkdir $BUILD_PACK/etc/pam.d
    cat > $BUILD_PACK/etc/pam.d/vsftpd << "EOF"
auth       required     /lib/security/pam_listfile.so item=user sense=deny \
                                                      file=/etc/ftpusers \
                                                      onerr=succeed
auth       required     pam_shells.so
auth       include      system-auth
account    include      system-account
session    include      system-session
EOF

    # Add init script
    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/vsftpd <<"EOF"
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
# Provides:            ftpd
# Required-Start:      $remote_fs
# Should-Start:
# Required-Stop:       $remote_fs
# Should-Stop:
# Default-Start:       3 4 5
# Default-Stop:        0 1 2 6
# Short-Description:   vsftpd daemon
# Description:         Very Secure FTP Daemon
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting vsFTP Server..."
      start_daemon /usr/sbin/vsftpd
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping vsFTP Server..."
      killproc /usr/sbin/vsftpd
      evaluate_retval
      ;;
   reload)
      log_info_msg "Reloading vsFTP Server..."
      killproc /usr/sbin/vsftpd -HUP
      evaluate_retval
      ;;
   restart)
      $0 stop
      sleep 1
      $0 start
      ;;
   status)
      statusproc /usr/sbin/vsftpd
      ;;
   *)
      echo "Usage: $0 {start|stop|reload|restart|status}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/vsftpd
    for i in 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/vsftpd $BUILD_PACK/etc/rc.d/rc$i.d/S32vsftpd
    done
    for i in 0 1 2 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/vsftpd $BUILD_PACK/etc/rc.d/rc$i.d/K28vsftpd
    done
}

install_setup()
{
    /etc/init.d/vsftpd start
}

remove_setup()
{
    /etc/init.d/vsftpd stop
}
