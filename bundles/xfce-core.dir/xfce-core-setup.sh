#!/bin/bash

script_run()
{
    bandit_log "Setting up XFCE4..."

    update-mime-database /usr/share/mime

    update-desktop-database

}
