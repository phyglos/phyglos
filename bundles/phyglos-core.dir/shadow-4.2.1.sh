#!/bin/bash

build_compile()
{
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

    sed -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	-e 's@/var/spool/mail@/var/mail@' \
	-i etc/login.defs

    # Set first group to 1001, after the phy group
    sed -i 's/1000/1001/' etc/useradd

    ./configure                         \
	--sysconfdir=/etc               \
        --with-group-name-max-length=32

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    mv -v $BUILD_PACK/usr/bin/passwd $BUILD_PACK/bin
}

install_setup()
{
    bandit_log "Setting shadow passwords..."
    pwconv
    grpconv

    bandit_log "Setting root's password..."
    echo "root:phyglos" | chpasswd
}




