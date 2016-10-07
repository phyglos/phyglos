#!/bin/bash

script_run()
{
    # Create SSH dir
    install -m700 -d /var/lib/sshd 
    chown root:sys /var/lib/sshd 

    # Create SSH deamon
    groupadd -g 50 ssh
    
    useradd  -c 'SSH daemon'   \
             -d /var/lib/sshd  \
             -g ssh            \
             -s /bin/false     \
             -u 50 sshd
}

script_reverse()
{
    # Delete user and group
    userdel sshd
    groupdel ssh

    # Delete directories
    rm -rf /var/lib/sshd
}
