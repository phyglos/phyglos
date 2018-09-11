#!/bin/bash

build_compile()
{
    cat > mozconfig << "EOF"
# If you have a multicore machine, all cores will be used by default.
# If desired, you can reduce the number of cores used, e.g. to 1, by
# uncommenting the next line and setting a valid number of CPU cores.
#mk_add_options MOZ_MAKE_FLAGS="-j1"

# If you have installed DBus-Glib comment out this line:
#ac_add_options --disable-dbus

# If you have installed dbus-glib, and you have installed (or will install)
# wireless-tools, and you wish to use geolocation web services, comment out
# this line
ac_add_options --disable-necko-wifi

# Uncomment this option if you wish to build with gtk+-2
#ac_add_options --enable-default-toolkit=cairo-gtk2

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
ac_add_options --enable-startup-notification

# Uncomment the following option if you have not installed PulseAudio
ac_add_options --disable-pulseaudio
# and uncomment this if you installed alsa-lib instead of PulseAudio
ac_add_options --enable-alsa

# If you have installed GConf, comment out this line
#ac_add_options --disable-gconf

# Comment out following options if you have not installed
# recommended dependencies:
ac_add_options --enable-system-sqlite
ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss

####ac_add_options --with-system-icu

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=browser

ac_add_options --disable-crashreporter
#ac_add_options --disable-updater
ac_add_options --disable-tests

# Stripping is now enabled by default.
# Uncomment these lines if you need to run a debugger:
#ac_add_options --disable-strip
#ac_add_options --disable-install-strip

ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier

# From firefox-40, using system cairo causes firefox to crash
# frequently when it is doing background rendering in a tab.
#ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-pthreads

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/firefox-build-dir
EOF

make -f client.mk
}


build_pack()
{
    make -f client.mk \
	DESTDIR=$BUILD_PACK INSTALL_SDK= \
	install

    bandit_mkdir $BUILD_PACK/usr/lib/mozilla/plugins 
    ln -sfv ../../mozilla/plugins $BUILD_PACK/usr/lib/firefox-52.9.0/browser

    bandit_mkdir $BUILD_PACK/usr/share/pixmaps
    ln -sfv /usr/lib/firefox-45.9.0/browser/icons/mozicon128.png \
            $BUILD_PACK/usr/share/pixmaps/firefox.png

    bandit_mkdir $BUILD_PACK/usr/share/applications
    cat > $BUILD_PACK/usr/share/applications/firefox.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Firefox Web Browser
Comment=Browse the World Wide Web
GenericName=Web Browser
Type=Application
Icon=firefox
Categories=GNOME;GTK;Network;WebBrowser;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;
Exec=firefox %u
Terminal=false
StartupNotify=true
EOF
}
