#!/bin/bash

script_run()
{

    bandit_log "Setting up system configuration files..."

    #---
    # Create /etc/dircolors
    #---

    dircolors -p > /etc/dircolors

    #---
    # Create /etc/fstab
    #---

    local PHY_PART=$BANDIT_TARGET_PART
    local PHY_TYPE=$BANDIT_TARGET_PART_TYPE
    local PHY_SWAP=$BANDIT_TARGET_SWAP
    
    cat > /etc/fstab << EOF
# file system  mount-point  type      options             dump  fsck
#                                                              order
$PHY_PART      /            $PHY_TYPE defaults            1     1
$PHY_SWAP      swap         swap      pri=1               0     0
proc           /proc        proc      nosuid,noexec,nodev 0     0
sysfs          /sys         sysfs     nosuid,noexec,nodev 0     0
devpts         /dev/pts     devpts    gid=5,mode=620      0     0
tmpfs          /run         tmpfs     defaults            0     0
devtmpfs       /dev         devtmpfs  mode=0755,nosuid    0     0
EOF

    #---
    # Configure SystemV /etc/inittab
    #---

    cat > /etc/inittab << EOF
id:3:initdefault:

si::sysinit:/etc/rc.d/init.d/rc S

l0:0:wait:/etc/rc.d/init.d/rc 0
l1:S1:wait:/etc/rc.d/init.d/rc 1
l2:2:wait:/etc/rc.d/init.d/rc 2
l3:3:wait:/etc/rc.d/init.d/rc 3
l4:4:wait:/etc/rc.d/init.d/rc 4
l5:5:wait:/etc/rc.d/init.d/rc 5
l6:6:wait:/etc/rc.d/init.d/rc 6

ca:12345:ctrlaltdel:/sbin/shutdown -t1 -a -r now

su:S016:once:/sbin/sulogin

1:2345:respawn:/sbin/agetty --noclear tty1 9600
2:2345:respawn:/sbin/agetty tty2 9600
3:2345:respawn:/sbin/agetty tty3 9600
4:2345:respawn:/sbin/agetty tty4 9600
5:2345:respawn:/sbin/agetty tty5 9600
6:2345:respawn:/sbin/agetty tty6 9600
EOF

    #--- 
    # Create /etc/inputrc
    #---

    cat > /etc/inputrc << EOF
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

"\e[1;5C": forward-word
"\e[1;5D": backward-word
"\e[5C": forward-word
"\e[5D": backward-word
"\e\e[C": forward-word
"\e\e[D": backward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line
EOF

    #---
    # Create /etc/shells
    #---

    cat > /etc/shells << EOF
/bin/sh
/bin/bash
EOF

}
