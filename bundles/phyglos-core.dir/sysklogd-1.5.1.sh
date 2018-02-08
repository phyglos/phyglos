#!/bin/bash

build_compile()
{
    sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
    sed -i 's/union wait/int/' syslogd.c
    
    make
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/sbin
    make BINDIR=$BUILD_PACK/sbin install
    
    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/syslog.conf << "EOF"
auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *
EOF

}
