#!/bin/bash

script_run()
{
    # Show results in main log file
    (
	echo
	bandit_msg "...updating pci.ids..."
	echo
	/usr/sbin/update-pciids 
	echo
	
	bandit_msg "...updating usb.ids..."
	echo
	wget http://www.linux-usb.org/usb.ids -O /usr/share/hwdata/usb.ids 
	echo

	bandit_msg "...updating oui.txt..."
	echo
	wget http://standards.ieee.org/regauth/oui/oui.txt -O /usr/share/hwdata/oui.txt
	echo

	bandit_msg "...updating manuf.txt..."
	echo
	wget http://anonsvn.wireshark.org/wireshark/trunk/manuf -O /usr/share/hwdata/manuf.txt
	echo

    ) 1>&2
}

script_reverse()
{
    rm -vf /usr/share/hwdata/pci.ids*
    rm -vf /usr/share/hwdata/usb.ids
    rm -vf /usr/share/hwdata/oui.txt
    rm -vf /usr/share/hwdata/manuf.txt
}

