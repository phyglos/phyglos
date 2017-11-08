#!/bin/bash

script_run()
{
    # Create group for Wireshark users
    groupadd -g 62 wireshark

    # Add the phy user to the group
    gpasswd -a phy wireshark
}

script_reverse()
{
    # Remove the phy user from the group
    gpasswd -d phy wireshark

    # Delete group
    groupdel wireshark
}
