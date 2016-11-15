#!/bin/bash

build_compile()
{
    echo "#define VSF_BUILD_SSL" >> builddefs.h
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
}

install_setup()
{
    # Start the service
    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-vsftpd
      /etc/init.d/vsftpd start
    popd
}
