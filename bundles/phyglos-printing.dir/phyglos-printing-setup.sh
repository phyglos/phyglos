#!/bin/bash

script_run()
{
    # Create CUPS daemon 'lp'
    useradd -c "Print Service User" -d /var/spool/cups -g lp -s /bin/false -u 9 lp

    # Create group for printing users 'lpadmin'
    groupadd -g 19 lpadmin
    
    # Add user phy to lpadmin group
    gpasswd -a phy lpadmin
}

script_reverse()
{
    # Remove user phy from lpadmin group
    gpasswd -d phy lpadmin

    # Delete CUPS user and group
    userdel lp
    groupdel lpadmin
}
