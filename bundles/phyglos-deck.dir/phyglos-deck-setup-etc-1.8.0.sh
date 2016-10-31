#!/bin/bash

script_run()
{
    # Setup daemons and groups
    
    groupadd -g 22 cron
    useradd -u 22 -g cron        \
	    -c "FCron  daemom"   \
	    -d /dev/null         \
	    -s /bin/false        \
	    crond

    groupadd -g 87 ntp
    useradd -u 87 -g ntp                      \
	    -c "Network Time Protocol daemom" \
	    -d /var/lib/ntp                   \
	    -s /bin/false                     \
	    ntpd
}
