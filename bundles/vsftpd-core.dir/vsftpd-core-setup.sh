#!/bin/bash

script_run()
{
    # Create group for vsFTP users 
    groupadd -g 45 ftp
    groupadd -g 47 vsftpd

    # Create ftp user
    install -v -d -m 0755 /home/ftp
    useradd -c "anonymous_user" \
	    -g ftp -u 45    \
	    -d /home/ftp    \
	    -s /bin/false   \
            ftp

    # Create vsftp daemon
    useradd -c "vsFTPd Daemon" \
	    -d /dev/null       \
	    -g vsftpd -u 47    \
	    -s /bin/false      \
	    vsftpd
}

script_reverse()
{
    # Delete users 
    userdel  ftp
    userdel  vsftpd

    # Remove directories
    rm -vrf /home/ftp
    rm -vrf /var/mail/ftp
    rm -vrf /var/mail/vsftpd
}
