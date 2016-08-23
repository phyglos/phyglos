#!/bin/bash

script_run()
{

bandit_log "Setting up network configuration files..."

cat > /etc/hostname << EOF
$PHY_HOSTNAME
EOF

cat > /etc/hosts << EOF
127.0.0.1 localhost
$PHY_LAN_IP4 $PHY_HOSTNAME.$PHY_DOMAIN
EOF

cat > /etc/resolv.conf << EOF
domain $PHY_DOMAIN
nameserver $PHY_DNS1
nameserver $PHY_DNS2
EOF

cat > /etc/sysconfig/ifconfig.eth0 << EOF
ONBOOT=yes
IFACE=eth0
SERVICE=ipv4-static
IP=$PHY_LAN_IP4
GATEWAY=$PHY_LAN_GATEWAY
PREFIX=$PHY_LAN_PREFIX
BROADCAST=$PHY_LAN_BROADCAST
EOF
}
