#!/bin/bash

build_compile()
{
    ./configure                           \
	--prefix=/usr                     \
        --sysconfdir=/etc                 \
        --libdir=/usr/lib                 \
        --enable-securedir=/lib/security  \
        --docdir=/usr/share/doc/Linux-PAM-1.2.1

    make
}

build_test_level=1
build_test()
{
    if [ -d /etc/pam.d ]; then 
	bandit_msg "PAM installed. Using actual /etc/pam.d for tests..."
	make check
    else
	bandit_msg "PAM not installed. Creating temporary /etc/pam.d for tests..."
	install -v -m755 -d /etc/pam.d
	cat > /etc/pam.d/other << "EOF"
auth     required       pam_deny.so
account  required       pam_deny.so
password required       pam_deny.so
session  required       pam_deny.so
EOF
        make check
	bandit_msg "Removing temporary /etc/pam.d..."
	rm -rfv /etc/pam.d
    fi
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chmod -v 4755 $BUILD_PACK/sbin/unix_chkpwd

    for file in pam pam_misc pamc
    do
	mv -v $BUILD_PACK/usr/lib/lib${file}.so.* $BUILD_PACK/lib
	ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/lib${file}.so) $BUILD_PACK/usr/lib/lib${file}.so
    done

    bandit_mkdir $BUILD_PACK/etc/pam.d
    cat > $BUILD_PACK/etc/pam.d/system-account << "EOF"
account   required    pam_unix.so
EOF

    cat > $BUILD_PACK/etc/pam.d/system-auth << "EOF"
auth      required    pam_unix.so
EOF

    cat > $BUILD_PACK/etc/pam.d/system-session << "EOF"
session   required    pam_unix.so
EOF

    # Password with Cracklib installed.
    cat > $BUILD_PACK/etc/pam.d/system-password << "EOF"
# check new passwords for strength (man pam_cracklib)
password  required    pam_cracklib.so   type=Linux retry=3 difok=5 \
                                        difignore=23 minlen=9 dcredit=1 \
                                        ucredit=1 lcredit=1 ocredit=1 \
                                        dictpath=/lib/cracklib/pw_dict
# use sha512 hash for encryption, use shadow, and use the
# authentication token (chosen password) set by pam_cracklib
# above (or any previous modules)
password  required    pam_unix.so       sha512 shadow use_authtok
EOF
    
    cat > $BUILD_PACK/etc/pam.d/other << "EOF"
auth        required        pam_warn.so
auth        required        pam_deny.so
account     required        pam_warn.so
account     required        pam_deny.so
password    required        pam_warn.so
password    required        pam_deny.so
session     required        pam_warn.so
session     required        pam_deny.so
EOF
}
