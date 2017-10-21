#!/bin/bash

script_run()
{
    # Create group for CUPS daemon
    groupadd -g 9 lp

    # Create CUPS daemon 'lp'
    useradd -c "CUPS daemon" \
	    -d /var/spool/cups \
	    -s /bin/false \
	    -g lp \
	    -u 9 lp

    # Create group for printing users 'lpadmin'
    groupadd -g 19 lpadmin
    
    # Add user phy to lpadmin group
    gpasswd -a phy lpadmin
}

script_reverse()
{
    # Remove user phy from lpadmin group
    gpasswd -d phy lpadmin

    # Delete CUPS user and groups
    userdel lp
    rm -rf /var/mail/lp   
    groupdel lpadmin
    groupdel lp

    # Delete CUPS work directories
    rm -rf /etc/cups
    rm -rf /usr/lib/cups
    rm -rf /usr/share/cups
    rm -rf /run/cups
    rm -rf /var/cache/cups
    rm -rf /var/log/cups
    rm -rf /var/spool/cups
}
