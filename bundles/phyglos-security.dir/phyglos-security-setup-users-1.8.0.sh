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
    cat > /etc/sudoers.d/phyglos << "EOF"
## Allow the phy group to sudo all WITH password
%phy ALL=(ALL) ALL

## Allow the phy user to sudo all WITHOUT password
phy ALL=(ALL) NOPASSWD: ALL
EOF

    # Give ownership of $BANDIT_HOME to phy user
    chown -R phy:phy $BANDIT_HOME

    bandit_log "Locking down root account..."

    passwd -l root
}
