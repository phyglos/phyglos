#!/bin/bash

script_run()
{

bandit_log "Setting up network configuration files..."

cat > /etc/sysconfig/ifconfig.eth0 << EOF
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=$PHY_LAN_IP4_ADDRESS
PREFIX=$PHY_LAN_IP4_PREFIX
GATEWAY=$PHY_LAN_IP4_GATEWAY
BROADCAST=$PHY_LAN_IP4_BROADCAST
EOF

cat > /etc/hostname << EOF
$PHY_HOSTNAME
EOF

cat > /etc/hosts << EOF
127.0.0.1 localhost
$PHY_LAN_IP4_ADDRESS $PHY_HOSTNAME.$PHY_DOMAINNAME
EOF

cat > /etc/resolv.conf << EOF
domain $PHY_DOMAINNAME
nameserver $PHY_LAN_IP4_DNS
EOF

}
