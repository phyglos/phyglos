#!/bin/bash

build_compile()
{
    cat > mozconfig << "EOF"
# If you have a multicore machine, the build may be faster if using parallel
# jobs. The build system automatically adds -jN to the "make" flags, where N
# is the number of CPU cores. The option below is therefore useless, unless
# you want to use a smaller number of jobs:
#mk_add_options MOZ_MAKE_FLAGS="-j1"

# If you have installed DBus-Glib comment out this line:
#ac_add_options --disable-dbus

# If you have installed wireless-tools comment out this line:
ac_add_options --disable-necko-wifi

# GStreamer is necessary for H.264 video playback in HTML5 Video Player;
# to be enabled, also remember to set "media.gstreamer.enabled" to "true"
# in about:config. If you have GStreamer 1.x.y, comment out this line and
# uncomment the following one:
#ac_add_options --disable-gstreamer
ac_add_options --enable-gstreamer=1.0

# Uncomment these lines if you have installed optional dependencies:
#ac_add_options --enable-system-hunspell
ac_add_options --enable-startup-notification

# Comment out following option if you have PulseAudio installed
ac_add_options --disable-pulseaudio

# Comment out following option if you have gconf installed
ac_add_options --disable-gconf

# If you want to compile the Mozilla Calendar, uncomment this line:
#ac_add_options --enable-calendar

# Comment out following options if you have not installed
# recommended dependencies:
# Do not use system SQLite for Thunderbird 45.x
# ac_add_options --enable-system-sqlite
#ac_add_options --with-system-libevent
ac_add_options --with-system-libvpx
ac_add_options --with-system-nspr
ac_add_options --with-system-nss
ac_add_options --with-system-icu

# The BLFS editors recommend not changing anything below this line:
ac_add_options --prefix=/usr
ac_add_options --enable-application=mail

ac_add_options --disable-crashreporter
ac_add_options --disable-updater
ac_add_options --disable-debug
ac_add_options --disable-tests

ac_add_options --enable-optimize
ac_add_options --enable-strip
ac_add_options --enable-install-strip

ac_add_options --enable-gio
ac_add_options --enable-official-branding
ac_add_options --enable-safe-browsing
ac_add_options --enable-url-classifier

# Use internal cairo due to reports of unstable execution with
# system cairo
#ac_add_options --enable-system-cairo
ac_add_options --enable-system-ffi
ac_add_options --enable-system-pixman

ac_add_options --with-pthreads

ac_add_options --with-system-bz2
ac_add_options --with-system-jpeg
ac_add_options --with-system-png
ac_add_options --with-system-zlib

#mk_add_options MOZ_OBJDIR=@TOPSRCDIR@/thunderbird-build-dir
EOF

    make -f client.mk
}


build_pack()
{
    make -f client.mk \
	 DESTDIR=$BUILD_PACK \
	 INSTALL_SDK=        \
	 install
    
#    chown -R 0:0 $BUILD_PACK/usr/lib/thunderbird-45.7.1

    bandit_mkdir $BUILD_PACK/usr/share/pixmaps
    ln -sfv /usr/lib/thunderbird-45.7.1/chrome/icons/default/default256.png \
       $BUILD_PACK/usr/share/pixmaps/thunderbird.png

    bandit_mkdir $BUILD_PACK/usr/share/applications
    cat > $BUILD_PACK/usr/share/applications/thunderbird.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Thunderbird Mail
Comment=Send and receive mail with Thunderbird
GenericName=Mail Client
Exec=thunderbird %u
Terminal=false
Type=Application
Icon=thunderbird
Categories=Application;Network;Email;
MimeType=application/xhtml+xml;text/xml;application/xhtml+xml;application/xml;application/rss+xml;x-scheme-handler/mailto;
StartupNotify=true
EOF
}

