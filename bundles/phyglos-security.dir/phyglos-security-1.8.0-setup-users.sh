#!/bin/bash

script_run()
{

    bandit_log "Creating user 'phy' in group 'phy'..."

    useradd -m --uid 1000 --gid 1000 phy
    # Set the password of the phy user
    echo "phy:${PHY_PHYUSER_PSW}" | chpasswd

    # Give ownership of $BANDIT_HOME to phy user
    chown -R phy:phy $BANDIT_HOME

    # Configure phy user and phy groups as sudoers
    cat > /etc/sudoers.d/phyglos << "EOF"
## Allow the phy group to sudo all WITH password
%phy ALL=(ALL) ALL

## Allow the phy user to sudo all WITHOUT password
phy ALL=(ALL) NOPASSWD: ALL
EOF

    bandit_log "Locking down root account..."

    passwd -l root
}
