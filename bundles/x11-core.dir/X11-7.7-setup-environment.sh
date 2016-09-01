#!bin/bash

script_run()
{
    bandit_log "Creating X11 environment for target $BANDIT_TARGET_MACH..."

    # Create xorg.sh in /etc/profile.d
    cat > /etc/profile.d/X11.sh <<EOF
XORG_PREFIX="$PHY_XORG_PREFIX"
export XORG_PREFIX

alias x="startx &> ~/.x11-session.log"
EOF
    chmod 644 /etc/profile.d/X11.sh

    # Configuration in case of building in optional directory
    if [ "$PHY_XORG_BASE" != "" ]; then
	cat >> /etc/profile.d/X11.sh <<EOF

# Configure optional X11 directory
pathappend $PHY_XORG_PREFIX/bin             PATH
pathappend $PHY_XORG_PREFIX/lib/pkgconfig   PKG_CONFIG_PATH
pathappend $PHY_XORG_PREFIX/share/pkgconfig PKG_CONFIG_PATH

pathappend $PHY_XORG_PREFIX/lib             LIBRARY_PATH
pathappend $PHY_XORG_PREFIX/include         C_INCLUDE_PATH
pathappend $PHY_XORG_PREFIX/include         CPLUS_INCLUDE_PATH

ACLOCAL='aclocal -I $PHY_XORG_PREFIX/share/aclocal'

export PATH PKG_CONFIG_PATH ACLOCAL LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH
EOF

	cat > /etc/ld.so.conf.d/X11.conf <<EOF
$PHY_XORG_PREFIX/lib
EOF
	bandit_backup /etc/man_db.conf
	sed "s@/usr/X11R6@$PHY_XORG_PREFIX@g" -i /etc/man_db.conf

	# Create X11 links
#	ln -svf $PHY_XORG_PREFIX              /usr/X11R6
	ln -svf $PHY_XORG_PREFIX/include/X11  /usr/include/X11
	ln -svf $PHY_XORG_PREFIX/lib/X11      /usr/lib/X11
	ln -svf $PHY_XORG_PREFIX/share/X11    /usr/share/X11

	install -v -d -m755 /usr/share/fonts                               
	ln -svfn $PHY_XORG_PREFIX/share/fonts/X11/OTF /usr/share/fonts/X11-OTF 
	ln -svfn $PHY_XORG_PREFIX/share/fonts/X11/TTF /usr/share/fonts/X11-TTF

	# Create X11 libs dirs
	install -v -m755 -d $PHY_XORG_PREFIX
	case $BANDIT_TARGET_MACH in
	    x86) 
		install -v -m755 -d $PHY_XORG_PREFIX/lib
		;;
	    x86_64) 
		install -v -m755 -d $PHY_XORG_PREFIX/lib64
		ln -svf lib64 $PHY_XORG_PREFIX/lib
		;;
	esac
    fi

    # Make changes inmediately available to the running bundle
    source /etc/profile.d/X11.sh
    export XORG_PREFIX
    export PATH PKG_CONFIG_PATH ACLOCAL LIBRARY_PATH C_INCLUDE_PATH CPLUS_INCLUDE_PATH

    echo
    bandit_msg "Created /etc/profile.d/X11.sh..."
    cat  /etc/profile.d/X11.sh
}
