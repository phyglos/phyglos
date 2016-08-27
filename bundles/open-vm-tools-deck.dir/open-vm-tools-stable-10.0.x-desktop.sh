#!/bin/bash

build_compile()
{
    cd open-vm-tools

    autoreconf -i -Wnone
    
    ./configure             \
	--prefix=/usr       \
	--sysconfdir=/etc   \
	--without-gtkmm     \
	--without-kernel-modules    \
	--without-ssl       \
	--without-xerces    \
	--with-x            \
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

    # Create SysV init scripts
    bandit_mkdir $BUILD_PACK/etc/init.d/  
    cat > $BUILD_PACK/etc/init.d/vmtoolsd <<EOF
#!/bin/sh
#
# vmtoolsd - Open VM Tools Daemon
#
# Description : Starts Open VM Tools for VMware guests
#
# Author      : alz@phyglos.org
#
# Provides:            vmtoolsd
# Required-Start:      
# Should-Start:
# Required-Stop:       sendsignals
# Should-Stop:
# Default-Start:       S
# Default-Stop:        0 1 6
# Short-Description:   Starts Open VM Tools for VMware guests
# Description:         Starts Open VM Tools for VMware guests

. /lib/lsb/init-functions

case "\$1" in
   start)
      log_info_msg "Starting Open VM Tools Daemon..."
      /usr/bin/vmtoolsd --background=/var/run/vmtoolsd.pid
      evaluate_retval
      ;;

   stop)
      log_info_msg "Stopping Open VM Tools Daemon..."
      kill \$(cat /var/run/vmtoolsd.pid)
      evaluate_retval
      ;;

   restart)
      \$0 stop
      \$0 start
      ;;

   *)
      echo "Usage: \$0 {start|stop}"
      exit 1
      ;;
esac
EOF
    chmod 754 $BUILD_PACK/etc/init.d/vmtoolsd
    
    mkdir -pv $BUILD_PACK/etc/rc.d/rc{0,1,2,3,4,5,6,S}.d  
    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc2.d/S80vmtoolsd
    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc3.d/S80vmtoolsd
    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc4.d/S80vmtoolsd
    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc5.d/S80vmtoolsd

    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc0.d/K05vmtoolsd
    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc1.d/K05vmtoolsd
    ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rc6.d/K05vmtoolsd
    # ln -sf ../init.d/vmtoolsd $BUILD_PACK/etc/rc.d/rcS.d/S80vmtoolsd

    # Keep clean /sbin
    rm -rd $BUILD_PACK/sbin
}

install_setup()
{
    /etc/init.d/vmtoolsd start
}

