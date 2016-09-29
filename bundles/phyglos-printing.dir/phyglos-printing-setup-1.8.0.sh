#!/bin/bash

script_run()
{
    # Create CUPS deamon
    useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp

    # Create group for printing users 
    groupadd -g 19 lpadmin
    # Add user phy to lpadmin
    usermod -a -G lpadmin phy
}

script_reverse()
{
    # Remove user phy to lpadmin
    gpasswd -d phy lpadmin

    # Delete user and group
    userdel lp
    groupdel lpadmin
}
