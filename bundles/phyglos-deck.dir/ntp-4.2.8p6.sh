#!/bin/bash

build_compile()
{
    groupadd -g 87 ntpd
    useradd -c "Network Time Protocol daemom" \
	    -d /var/lib/ntp                   \
	    -u 87 -g ntpd                     \
	    -s /bin/false                     \
	    ntpd

    ./configure               \
	--prefix=/usr         \
	--bindir=/usr/sbin    \
	--sysconfdir=/etc     \
	--enable-linuxcaps    \
	--with-lineeditlibs=readline \
	--docdir=/usr/share/doc/ntp-4.2.8p6
    
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

    bandit_mkdir $BUILD_PACK/var/lib
    install -v -o ntp -g ntp -d $BUILD_PACK/var/lib/ntp

    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/ntp.conf << "EOF"
# Asia
server 0.asia.pool.ntp.org

# Australia
server 0.oceania.pool.ntp.org

# Europe
server 0.europe.pool.ntp.org

# North America
server 0.north-america.pool.ntp.org

# South America
server 2.south-america.pool.ntp.org

driftfile /var/lib/ntp/ntp.drift
pidfile   /var/run/ntpd.pid

leapfile  /etc/ntp.leapseconds

# Security session
restrict    default limited kod nomodify notrap nopeer noquery
restrict -6 default limited kod nomodify notrap nopeer noquery

restrict 127.0.0.1
restrict ::1
EOF
}

install_setup()
{
    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-ntpd
      /etc/init.d/ntpd start
    popd
}
