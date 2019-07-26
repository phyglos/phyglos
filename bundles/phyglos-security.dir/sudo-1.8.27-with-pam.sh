#!/bin/bash

build_compile()
{
    ./configure                    \
	--prefix=/usr              \
        --libexecdir=/usr/lib      \
        --with-secure-path         \
        --with-all-insults         \
        --with-env-editor          \
        --with-passprompt="[sudo] password for %p: " \
	--with-pam                 \
        --docdir=/usr/share/doc/sudo-1.8.27

    make
}

build_test_level=1
build_test()
{
    env LC_ALL=C make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -sfv libsudo_util.so.0.0.0 $BUILD_PACK/usr/lib/sudo/libsudo_util.so.0

    bandit_mkdir $BUILD_PACK/etc/pam.d
    cat > $BUILD_PACK/etc/pam.d/sudo << "EOF"
# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session
EOF
    chmod 644 $BUILD_PACK/etc/pam.d/sudo
}
