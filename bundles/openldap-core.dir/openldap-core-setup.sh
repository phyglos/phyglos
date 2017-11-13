#!/bin/bash

script_run()
{
    # Create group for LDAP
    groupadd -g 83 ldap

    # Create ldap daemon
    useradd  -c "OpenLDAP Daemon" \
             -d /var/lib/openldap \
	     -g ldap -u 83        \
             -s /bin/false        \
	     ldapd
}

script_reverse()
{
    # Delete user
    userdel ldapd

    # Delete group
    groupdel ldap

    # Remove directories
    rm -vrf /var/mail/ldapd
    rm -vrf /var/lib/openldap
}
