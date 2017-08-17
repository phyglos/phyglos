#!/bin/bash

build_compile()
{
    ./configure                        \
	--prefix=/usr                  \
        --sysconfdir=/etc              \
        --localstatedir=/var           \
	--disable-doxygen-docs         \
        --disable-xml-docs             \
        --disable-static               \
        --disable-systemd              \
        --without-systemdsystemunitdir \
        --with-console-auth-dir=/run/console/ \
        --docdir=/usr/share/doc/dbus-1.10.6   \
	--with-dbus-user=dbusd

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chown -v root:dbus $BUILD_PACK/usr/libexec/dbus-daemon-launch-helper
    chmod -v 4750      $BUILD_PACK/usr/libexec/dbus-daemon-launch-helper
}

install_setup()
{
    # Create the daemon group and user
    groupadd -g 18 dbus
    useradd -c "D-Bus daemom"   \
	    -d /var/lib/dbus    \
	    -u 18 -g dbus       \
	    -s /bin/false       \
	    dbusd

    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-dbus
      /etc/init.d/dbus start
    popd
}
