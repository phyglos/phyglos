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
}

install_setup()
{
    # Use PAM for ssh login
    sed 's@d/login@d/sshd@g' /etc/pam.d/login > /etc/pam.d/sshd
    chmod 644 /etc/pam.d/sshd
    echo "UsePAM yes" >> /etc/ssh/sshd_config

    # Disable root login
    echo "PermitRootLogin no" >> /etc/ssh/sshd_config
    
    # Generate server keys
    yes | ssh-keygen -f /etc/ssh/ssh_host_rsa_key   -N '' -t rsa
    yes | ssh-keygen -f /etc/ssh/ssh_host_dsa_key   -N '' -t dsa
    yes | ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa -b 521

    # Start the service
    pushd $BANDIT_HOME/lib/blfs-bootscripts
      make install-sshd
      /etc/init.d/sshd start
    popd
}
