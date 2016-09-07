#!/bin/bash

script_run()
{
    bandit_log "Creating X11 configuration default sections..."

    cat > /etc/X11/xorg.conf.d/xkb-defaults.conf << EOF
Section "InputClass"
    Identifier "XKB Defaults"
    MatchIsKeyboard "yes"
    Option "XkbMode" "${PHY_XORG_XKB_MODE}"
    Option "XkbLayout" "${PHY_XORG_XKB_LAYOUT}"
    Option "XkbOptions" "terminate:ctrl_alt_bksp"
EndSection
EOF

    #cat > /etc/X11/xorg.conf.d/videocard-0.conf << "EOF"
#Section "Device"
#    Identifier  "Videocard0"
#    Driver      "radeon"
#    VendorName  "Videocard vendor"
#    BoardName   "ATI Radeon 7500"
#    Option      "NoAccel" "true"
#EndSection
#EOF

    #cat > /etc/X11/xorg.conf.d/server-layout.conf << "EOF"
#Section "ServerLayout"
#    Identifier     "DefaultLayout"
#    Screen      0  "Screen0" 0 0
#    Screen      1  "Screen1" LeftOf "Screen0"
#    Option         "Xinerama"
#EndSection
#EOF

}
