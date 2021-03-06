#!/bin/bash

script_run()
{
    # Update desktop applications
    update-desktop-database
    
    # Update again icons cache
    gtk-update-icon-cache -qf /usr/share/icons/hicolor
    gtk-update-icon-cache -qf /usr/share/icons/Adwaita
    gtk-update-icon-cache -qf /usr/share/icons/gnome
    gtk-update-icon-cache -qf /usr/share/icons/nuoveXT2
    gtk-update-icon-cache -qf /usr/share/icons/Tango

    gdk-pixbuf-query-loaders --update-cache
}
