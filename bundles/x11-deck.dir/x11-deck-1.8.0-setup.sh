#!/bin/bash

script_run()
{
    # Update again icons cache
    gtk-update-icon-cache -qf /usr/share/icons/hicolor
    gtk-update-icon-cache -qf /usr/share/icons/Adwaita
    gtk-update-icon-cache -qf /usr/share/icons/gnome
    gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2
}
