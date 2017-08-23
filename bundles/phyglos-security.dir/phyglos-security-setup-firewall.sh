#!/bin/bash

script_run()
{

    bandit_log "Setting up initial firewall'..."

    cat > /etc/init.d/firewall << "EOF"
#!/bin/bash
#
# Copyright (C) 2017 Angel Linares Zapater
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License, version 2, as 
# published by the Free Software Foundation. See the COPYING file.
#
# This program is distributed WITHOUT ANY WARRANTY; without even the 
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  
#
### BEGIN INIT INFO
# Provides:          firewall
# Required-Start:    mountkernfs $local_fs
# Required-Stop:     $local_fs
# Default-Start:     3 4 5
# Default-Stop:      0 1 2 6
# Short-Description: phyglos-firewall
# Description:       Simple iptables firewall
### END INIT INFO

. /lib/lsb/init-functions

case "$1" in
    start)
        log_info_msg "Starting the firewall..."
	# Flush tables
	iptables -F
	iptables -t nat -F
	iptables -t mangle -F
	iptables -X

	# Prevent brute force attacks on SSH
	#iptables -A INPUT -p tcp --dport 22 -i eth1 -m state --state NEW -m recent  --set
	#iptables -A INPUT -p tcp --dport 22 -i eth1 -m state --state NEW -m recent  --update --seconds 30 --hitcount 3 -j DROP

	# Prevent DoS attacks on HTTP
	#iptables -A INPUT -p tcp --dport 80 -i eth1 -m limit --limit 5/minute --limit-burst 5 -j ACCEPT

	# Configure INPUT traffic
	#iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	#iptables -A INPUT -m state --state NEW -j ACCEPT
	#iptables -A INPUT -i lo -j ACCEPT

	# Configure FORWARD LAN (eth0) traffic
	#iptables -A FORWARD -i eth0 -o eth1 -j ACCEPT

	# Configure FORWARD WAN (eht1) traffic
	#iptables -A FORWARD -i eth1 -o eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
	#iptables -A FORWARD -i eth1 -o eth0 -j REJECT

	# Configure NAT
	#iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
	#iptables -t nat -A PREROUTING  -i eth1 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.100:8080

	# Enable routing
	echo 1 > /proc/sys/net/ipv4/ip_forward

        evaluate_retval
	;;
    stop)
        log_info_msg "Stopping the firewall..."
	# Flush tables
	iptables -F
	iptables -t nat -F
	iptables -t mangle -F
	iptables -X

	# Disable routing
	echo 0 > /proc/sys/net/ipv4/ip_forward

        evaluate_retval
	;;
    restart)
        log_info_msg "Restarting the firewall..."
	$0 stop
	$0 start
	;;
    status)
        echo
	echo "==========="
	echo "IPTABLES..."
	echo "==========="
	iptables -L -v -n
        echo
	echo "==========="
	echo "NAT..."
	echo "==========="
	iptables -L -t nat -v -n
        echo
	echo "==========="
	echo "MANGLE..."
	echo "==========="
	iptables -L -t mangle -v -n
        echo
	;;
    *)
	echo "Usage: $0 {start|stop|restart|status}" >&2
	exit 1
	;;
esac
exit 0
EOF
    chmod 754 /etc/init.d/firewall
    for i in 3 4 5; do
	ln -svf ../init.d/firewall /etc/rc.d/rc$i.d/S15firewall
    done
    for i in 0 1 2 6; do
	ln -svf ../init.d/firewall /etc/rc.d/rc$i.d/K60firewall
    done
}


