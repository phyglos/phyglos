#!/bin/bash

build_compile()
{
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in 
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \; 
    find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \; 
    find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \; 

    sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
	-e 's@/var/spool/mail@/var/mail@' etc/login.defs &&

    ./configure           \
	--sysconfdir=/etc \
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
    # Disable login program functionality provided by Linux-PAM
    install -v -m644 /etc/login.defs /etc/login.defs.orig 
    for FUNCTION in FAIL_DELAY               \
        FAILLOG_ENAB             \
        LASTLOG_ENAB             \
        MAIL_CHECK_ENAB          \
        OBSCURE_CHECKS_ENAB      \
        PORTTIME_CHECKS_ENAB     \
        QUOTAS_ENAB              \
        CONSOLE MOTD_FILE        \
        FTMP_FILE NOLOGINS_FILE  \
        ENV_HZ PASS_MIN_LEN      \
        SU_WHEEL_ONLY            \
        CRACKLIB_DICTPATH        \
        PASS_CHANGE_TRIES        \
        PASS_ALWAYS_WARN         \
        CHFN_AUTH ENCRYPT_METHOD \
        ENVIRON_FILE
    do
	sed -i "s/^${FUNCTION}/# &/" /etc/login.defs
    done

    cat > /etc/pam.d/login << "EOF"
# Set failure delay before next prompt to 3 seconds
auth      optional    pam_faildelay.so  delay=3000000

# Check to make sure that the user is allowed to login
auth      requisite   pam_nologin.so

# Check to make sure that root is allowed to login
# Disabled by default. You will need to create /etc/securetty
# file for this module to function. See man 5 securetty.
#auth      required    pam_securetty.so

# Additional group memberships - disabled by default
#auth      optional    pam_group.so

# include the default auth settings
auth      include     system-auth

# check access for the user
account   required    pam_access.so

# include the default account settings
account   include     system-account

# Set default environment variables for the user
session   required    pam_env.so

# Set resource limits for the user
session   required    pam_limits.so

# Display date of last login - Disabled by default
#session   optional    pam_lastlog.so

# Display the message of the day - Disabled by default
#session   optional    pam_motd.so

# Check user's mail - Disabled by default
#session   optional    pam_mail.so      standard quiet

# include the default session and password settings
session   include     system-session
password  include     system-password
EOF

    cat > /etc/pam.d/passwd << "EOF"
password  include     system-password
EOF

    cat > /etc/pam.d/su << "EOF"
# always allow root
auth      sufficient  pam_rootok.so
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session
EOF

    cat > /etc/pam.d/chage << "EOF"
# always allow root
auth      sufficient  pam_rootok.so

# include system defaults for auth account and session
auth      include     system-auth
account   include     system-account
session   include     system-session

# Always permit for authentication updates
password  required    pam_permit.so
EOF

    for PROGRAM in chfn chgpasswd chpasswd chsh groupadd groupdel \
	           groupmems groupmod newusers useradd userdel usermod
    do
	install -v -m644 /etc/pam.d/chage /etc/pam.d/${PROGRAM}
	sed -i "s/chage/$PROGRAM/" /etc/pam.d/${PROGRAM}
    done
    
    # Disable login.access and limits, unneeded after Linux-PAM
    [ -f /etc/login.access ] && mv -v /etc/login.access{,.orig}
    [ -f /etc/limits ]       && mv -v /etc/limits{,.orig}


}
