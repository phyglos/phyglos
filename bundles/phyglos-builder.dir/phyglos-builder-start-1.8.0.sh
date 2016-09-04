#!/bin/bash

script_run()
{
    # Prevent from raising the BUILDER except for user BANDIT
    if [ "$(id -un)" != "$BANDIT_USR" ];
       bandit_exit "BANDIT: Only the BANDIT user can raise the BUILDER"
    fi
}
