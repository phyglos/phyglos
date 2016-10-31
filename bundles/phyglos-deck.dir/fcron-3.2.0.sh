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

    # Start the service
    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-fcron
      /etc/init.d/fcron start
    popd  
}

