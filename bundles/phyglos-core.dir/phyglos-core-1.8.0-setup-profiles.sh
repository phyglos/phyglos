#!/bin/bash

script_run()
{

    bandit_log "Creating /etc/passwd and /etc/group files..."

cat > /etc/passwd <<EOF
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon user:/dev/null:/bin/false
messagebus:x:18:18:D-Bus daemon user:/var/run/dbus:/bin/false 
games:x:60:60:Games user:/dev/null:/bin/false
nobody:x:99:99:Unprivileged user:/dev/null:/bin/false
EOF

cat > /etc/group <<EOF
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
input:x:24:
mail:x:34:
games:x:60:
nogroup:x:99:
phy:x:1000:
users:x:1001:
EOF

    bandit_log "Configuring profile and login scripts..."

    #---
    # Create /etc/profile
    #---

    cat > /etc/profile << "EOF"
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# modifications by Dagmar d'Surreal <rivyqntzne@pbzpnfg.arg>

# System wide environment variables and startup programs.

# System wide aliases and functions should go in /etc/bashrc.  Personal
# environment variables and startup programs should go into
# ~/.bash_profile.  Personal aliases and functions should go into
# ~/.bashrc.

# Functions to help us manage paths.  Second argument is the name of the
# path variable to be modified (default: PATH)
pathremove () {
        local IFS=':'
        local NEWPATH
        local DIR
        local PATHVARIABLE=${2:-PATH}
        for DIR in ${!PATHVARIABLE} ; do
                if [ "$DIR" != "$1" ] ; then
                  NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
                fi
        done
        export $PATHVARIABLE="$NEWPATH"
}

pathprepend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="$1${!PATHVARIABLE:+:${!PATHVARIABLE}}"
}

pathappend () {
        pathremove $1 $2
        local PATHVARIABLE=${2:-PATH}
        export $PATHVARIABLE="${!PATHVARIABLE:+${!PATHVARIABLE}:}$1"
}

export -f pathremove pathprepend pathappend

# Set the initial path
export PATH=/bin:/usr/bin

if [ $EUID -eq 0 ] ; then
        pathappend /sbin:/usr/sbin
        unset HISTFILE
fi

# Setup some environment variables.
export HISTSIZE=1000
export HISTIGNORE="&:[bf]g:exit"

# Set some defaults for graphical systems
export XDG_DATA_DIRS=/usr/share

NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[32m\]"
BLUE="\[\e[1;34m\]"

CHROOT=""
if [[ $PS1 =~ "BUILDER" ]]; then CHROOT="[BUILDER]:"; fi
if [[ $PS1 =~ "TARGET" ]];  then CHROOT="[TARGET]:"; fi

if [ $EUID -eq 0 ]; then
  PS1="$RED\u$GREEN@\h:$CHROOT$BLUE\w # $NORMAL"
else
  PS1="$GREEN\u@\h:$CHROOT$BLUE\w \$ $NORMAL"
fi

for script in /etc/profile.d/*.sh ; do
  if [ -r $script ] ; then
    . $script
  fi
done
EOF

    #---
    # Create /etc/profile.d files
    #---

    install --directory --mode=0755 --owner=root --group=root /etc/profile.d

    cat > /etc/profile.d/bandit.sh << EOF
export BANDIT_HOME=$BANDIT_HOME
export PATH=\$PATH:$BANDIT_HOME/bin
EOF

    cat > /etc/profile.d/dircolors.sh << "EOF"
# Setup for /bin/ls and /bin/grep to support color, the alias is in /etc/bashrc.

if [ -f "/etc/dircolors" ] ; then
  eval $(dircolors -b /etc/dircolors)

  if [ -f "$HOME/.dircolors" ] ; then
     eval $(dircolors -b $HOME/.dircolors)
  fi
fi
EOF

     cat > /etc/profile.d/extrapaths.sh << "EOF"
if [ -d /usr/local/lib/pkgconfig ] ; then
    pathappend /usr/local/lib/pkgconfig PKG_CONFIG_PATH
fi

if [ -d /usr/local/bin ]; then
    pathprepend /usr/local/bin
fi
if [ -d /usr/local/sbin -a $EUID -eq 0 ]; then
    pathprepend /usr/local/sbin
fi

if [ -d ~/bin ]; then
    pathprepend ~/bin
fi

# Set current dir in PATH
if [ $EUID -gt 99 ]; then
    pathappend .
fi
EOF

     cat > /etc/profile.d/i18n.sh << EOF
export LANG=$PHY_LANG
EOF

    cat > /etc/profile.d/phyglos.sh << EOF
alias grep='grep --color=auto'
alias ls='ls -h --color=auto'
alias x='startx'
EOF

     cat > /etc/profile.d/readline.sh << "EOF"
if [ -z "$INPUTRC" -a ! -f "$HOME/.inputrc" ] ; then
  INPUTRC=/etc/inputrc
fi
export INPUTRC
EOF

     cat > /etc/profile.d/umask.sh << "EOF"
# By default, the umask should be set.
if [ "$(id -gn)" = "$(id -un)" -a $EUID -gt 99 ] ; then
  umask 002
else
  umask 022
fi
EOF

    #---
    # Create /etc/bashrc
    #---

    cat > /etc/bashrc << "EOF"
NORMAL="\[\e[0m\]"
RED="\[\e[1;31m\]"
GREEN="\[\e[32m\]"
BLUE="\[\e[1;34m\]"

CHROOT=""
if [[ $PS1 =~ "BUILDER" ]]; then CHROOT="[BUILDER]:"; fi
if [[ $PS1 =~ "TARGET" ]];  then CHROOT="[TARGET]:"; fi

if [ $EUID -eq 0 ]; then
  PS1="$RED\u$GREEN@\h:$CHROOT$BLUE\w # $NORMAL"
else
  PS1="$GREEN\u@\h:$CHROOT$BLUE\w \$ $NORMAL"
fi
EOF

    #---
    # Create root user bash files
    #---

    cat > /root/.bash_profile << "EOF"
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>
# updated by Bruce Dubbs <bdubbs@linuxfromscratch.org>

# Personal environment variables and startup programs.

# Personal aliases and functions should go in ~/.bashrc.  System wide
# environment variables and startup programs are in /etc/profile.
# System wide aliases and functions are in /etc/bashrc.

append () {
  # First remove the directory
  local IFS=':'
  local NEWPATH
  for DIR in $PATH; do
     if [ "$DIR" != "$1" ]; then
       NEWPATH=${NEWPATH:+$NEWPATH:}$DIR
     fi
  done

  # Then append the directory
  export PATH=$NEWPATH:$1
}

if [ -f "$HOME/.bashrc" ] ; then
  source $HOME/.bashrc
fi

if [ -d "$HOME/bin" ] ; then
  append $HOME/bin
fi

unset append
EOF

    cat > /root/.bashrc << "EOF"
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal aliases and functions.

# Personal environment variables and startup programs should go in
# ~/.bash_profile.  System wide environment variables and startup
# programs are in /etc/profile.  System wide aliases and functions are
# in /etc/bashrc.

if [ -f "/etc/bashrc" ] ; then
  source /etc/bashrc
fi
EOF

    cat > /root/.bash_logout << "EOF"
# Written for Beyond Linux From Scratch
# by James Robertson <jameswrobertson@earthlink.net>

# Personal items to perform on logout.

EOF

    #---
    # Install /etc/skel scripts
    #---

    bandit_mkdir /etc/skel
    cp -v /root/.bash_profile /etc/skel
    cp -v /root/.bashrc /etc/skel
    cp -v /root/.bash_logout /etc/skel

}
