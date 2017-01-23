#!/bin/bash

build_compile()
{
    bandit_log "Patching init scripts..."
    
    ## D-Bus
    # Patch service messages
    sed -e"s/D-Bus Messagebus/D-Bus/g" \
	-i blfs/init.d/dbus
    
    ## NTP  
    # Patch daemon user name
    sed -e"s/ntp:ntp/ntpd:ntp/g" \
	-i blfs/init.d/ntpd
    # Patch service name 
    sed -e"s/ing ntp/ing Network Time Protocol/g" \
	-i blfs/init.d/ntpd

    ## Remove the template file  
    rm -rf blfs/init.d/template
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/$BANDIT_HOME/lib/blfs-bootscripts
    cp -vR * $BUILD_PACK/$BANDIT_HOME/lib/blfs-bootscripts
}

