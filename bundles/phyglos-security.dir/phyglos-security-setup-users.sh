#!/bin/bash

script_run()
{
    bandit_log "Creating user 'phy' in group 'phy'..."

    # Create group and user phy 
    groupadd --gid 999 phy
    useradd --uid 999 --gid 999 -m phy

    # Set the password of the phy user
    echo "phy:${PHY_PHYUSER_PSW}" | chpasswd

    # Configure phy user and phy groups as sudoers
    cat > /etc/sudoers.d/_phyglos << "EOF"
## Set a well defined secure path 
Defaults:%phy secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

## Keep locale variables
Defaults:%phy env_keep += "LANG LANGUAGE LC_*

## Keep variables needed for BANDIT
Defaults:%phy env_keep += "BANDIT_HOME"
Defaults:%phy env_keep += "EDITOR"
Defaults:%phy env_keep += "LIBRARY_PATH PKG_CONFIG_PATH"
Defaults:%phy env_keep += "PRUNE_BIND_MOUNTS PRUNENAMES PRUNEPATHS PRUNEFS"

## Allow the phy group to sudo all WITH password
%phy ALL=(ALL) ALL

## Allow the phy user to sudo all WITHOUT password
phy ALL=(ALL) NOPASSWD: ALL
EOF

    # Set a random password of the root user and lock the account
    bandit_log "Locking root account..."

    local password
    bandit_random_string password
    echo "root:${password}" | chpasswd
    unset password
    
    passwd -l root
}
