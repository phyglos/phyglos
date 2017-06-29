#!/bin/bash

build_compile()
{
    ./autogen.sh
    
    ./configure       \
	--prefix=/usr \
	--with-acl
        
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
    cat > $BUILD_PACK/etc/logrotate.conf << EOF
# Rotate log files monthly
monthly

# Number of backups that will be kept
rotate 12

# Compress the backups with gzip
compress

# Don't mail logs to anybody
nomail

# If the log file is empty, it will not be rotated
notifempty

# Create new empty files after rotating old ones 
# This will create empty log files, with owner
# set to root, group set to sys, and permissions 644
create 0664 root sys

# Include additional logrotate configurations
include /etc/logrotate.d
EOF
    chmod -v 0644 $BUILD_PACK/etc/logrotate.conf

    
    bandit_mkdir $BUILD_PACK/etc/logrotate.d

    cat > $BUILD_PACK/etc/logrotate.d/lastlog << EOF
/var/log/lastlog {
dateext
}
EOF
    chmod -v 0644 $BUILD_PACK/etc/logrotate.d/lastlog

    cat > $BUILD_PACK/etc/logrotate.d/sys.log << EOF
/var/log/sys.log {
   size   100k
   postrotate
      /bin/killall -HUP syslogd
   endscript
}
EOF
    chmod -v 0644 $BUILD_PACK/etc/logrotate.d/sys.log

    cat > $BUILD_PACK/etc/logrotate.d/wtmp << EOF
/var/log/wtmp {
    create 0664 root utmp
}
EOF
    chmod -v 0644 $BUILD_PACK/etc/logrotate.d/wtmp
}

install_setup()
{
    # Force first rotation
    logrotate -f /etc/logrotate.conf
}
