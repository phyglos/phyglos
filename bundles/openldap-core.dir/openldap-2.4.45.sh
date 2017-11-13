#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/openldap-2.4.45-consolidated-1.patch 

    autoconf 

    ./configure               \
	--prefix=/usr         \
	--sysconfdir=/etc     \
        --localstatedir=/var  \
        --libexecdir=/usr/lib \
        --disable-static      \
        --disable-debug       \
        --with-tls=openssl    \
        --with-cyrus-sasl=no  \
        --enable-dynamic      \
        --enable-slapd        \
        --enable-crypt        \
        --enable-modules      \
        --enable-rlookups     \
        --enable-backends=mod \
        --disable-bdb         \
        --disable-hdb         \
        --disable-ndb         \
        --disable-sql         \
        --disable-shell       \
        --enable-overlays=mod 

    make depend   
    make   
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    chown   -v  root:ldap $BUILD_PACK/etc/init.d/slapd

    bandit_mkdir $BUILD_PACK/var/lib
    install -v -dm700 -o ldapd -g ldap $BUILD_PACK/var/lib/openldap

    bandit_mkdir $BUILD_PACK/var/run
    install -v -dm755 -o ldapd -g ldap $BUILD_PACK/var/run/openldap

    bandit_mkdir $BUILD_PACK/etc/openldap
    install -v -dm700 -o ldapd -g ldap $BUILD_PACK/etc/openldap/slapd.d
    chmod   -v    640     $BUILD_PACK/etc/openldap/slapd.{conf,ldif} 
    chown   -v  root:ldap $BUILD_PACK/etc/openldap/slapd.{conf,ldif}

    bandit_mkdir $BUILD_PACK/usr/share/doc/openldap-2.4.45
    cp -vfr doc/{drafts,rfc,guide} $BUILD_PACK/usr/share/doc/openldap-2.4.45

    # Add init script
    bandit_mkdir $BUILD_PACK/etc/init.d
    cat > $BUILD_PACK/etc/init.d/slapd <<"EOF"
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
# Provides:          slapd
# Required-Start:    $remote_fs $network $syslog
# Should-Start:
# Required-Stop:     $remote_fs $network $syslog
# Required-Stop:       $remote_fs
# Should-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: OpenLDAP server
# Description:       OpenLDAP server
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
   start)
      log_info_msg "Starting OpenLDAP server..."
      start_daemon /usr/sbin/slapd -u ldapd -g ldap
      evaluate_retval
      ;;
   stop)
      log_info_msg "Stopping OpenLDAP server..."
      killproc /usr/sbin/slapd
      evaluate_retval
      ;;
   restart)
      $0 stop
      sleep 1
      $0 start
      ;;
   status)
      statusproc /usr/sbin/slapd
      ;;
   *)
      echo "Usage: $0 {start|stop|restart|status}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/slapd
    for i in 2 3 4 5; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/slapd $BUILD_PACK/etc/rc.d/rc$i.d/S25slapd
    done
    for i in 0 1 6; do
	bandit_mkdir $BUILD_PACK/etc/rc.d/rc$i.d
	ln -svf ../init.d/slapd $BUILD_PACK/etc/rc.d/rc$i.d/K46slapd
    done
}

install_setup()
{
    /etc/init.d/slapd start
}

remove_setup()
{
    /etc/init.d/slapd stop
}
