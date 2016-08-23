#!/bin/bash

script_run()
{
    # Source XORG configuration
    source /etc/profile.d/x11.sh

    # Initialize CPAN 
    yes | cpan -i URU
}
