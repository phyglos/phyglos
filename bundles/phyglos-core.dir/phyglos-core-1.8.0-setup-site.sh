#!/bin/bash

script_run()
{

    bandit_log "Setting up site configuration files..."

    #---
    # Create /etc/lsb-release files
    #---

    cat > /etc/lsb-release <<"EOF"
DISTRIB_ID=\"$PHY_DISTRIB_ID"\
DISTRIB_RELEASE=\"$PHY_DISTRIB_RELEASE\"
DISTRIB_CODENAME=\"$PHY_DISTRIB_CODENAME\"
DISTRIB_DESCRIPTION=\"$PHY_DISTRIB_DESCRIPTION\"
LSB_VERSION=\"$PHY_LSB_VERSION\"
EOF

    #---
    # Create /etc/issue
    #---

    clear > /etc/issue
    cat   >> /etc/issue << EOF
[1;32m$PHY_DISTRIB_CODENAME -- $PHY_DISTRIB_DESCRIPTION [0m(\l)

EOF

    #---
    # Create /etc/sysconfig files
    #---

    cat > /etc/sysconfig/rc.site << "EOF"
# rc.site
# Optional parameters for boot scripts.

# Define custom colors used in messages printed to the screen

# Please consult `man console_codes` for more information
# under the "ECMA-48 Set Graphics Rendition" section
#
# Warning: when switching from a 8bit to a 9bit font,
# the linux console will reinterpret the bold (1;) to
# the top 256 glyphs of the 9bit font.  This does
# not affect framebuffer consoles

# These values, if specified here, override the defaults
#BRACKET="\\033[1;34m" # Blue
#FAILURE="\\033[1;31m" # Red
#INFO="\\033[1;36m"    # Cyan
#NORMAL="\\033[0;39m"  # Grey
#SUCCESS="\\033[1;32m" # Green
#WARNING="\\033[1;33m" # Yellow

# Use a colored prefix
# These values, if specified here, override the defaults
#BMPREFIX="     "
#SUCCESS_PREFIX="${SUCCESS}  *  ${NORMAL}"
#FAILURE_PREFIX="${FAILURE}*****${NORMAL}"
#WARNING_PREFIX="${WARNING} *** ${NORMAL}"

# Interactive startup
#IPROMPT="yes" # Whether to display the interactive boot prompt
#itime="3"    # The amount of time (in seconds) to display the prompt

# The total length of the distro welcome string, without escape codes
#wlen=$(echo "Welcome to ${DISTRO}" | wc -c )
#welcome_message="Welcome to ${INFO}${DISTRO}${NORMAL}"

# The total length of the interactive string, without escape codes
#ilen=$(echo "Press 'I' to enter interactive startup" | wc -c )
#i_message="Press '${FAILURE}I${NORMAL}' to enter interactive startup"

# Set scripts to skip the file system check on reboot
#FASTBOOT=yes

# Skip reading from the console
#HEADLESS=yes

# Write out fsck progress if yes
#VERBOSE_FSCK=no

# Speed up boot without waiting for settle in udev
#OMIT_UDEV_SETTLE=y

# Speed up boot without waiting for settle in udev_retry
#OMIT_UDEV_RETRY_SETTLE=yes

# Skip cleaning /tmp if yes
#SKIPTMPCLEAN=no

# For setclock
#UTC=PHY_UTC
#CLOCKPARAMS=

# For consolelog
#LOGLEVEL=5

# For network
#HOSTNAME=PHY_HOSTNAME

# Delay between TERM and KILL signals at shutdown
#KILLDELAY=3

# Optional sysklogd parameters
#SYSKLOGD_PARMS="-m 0"

# Console parameters
#UNICODE=PHY_UNICODE
#KEYMAP=PHY_KEYMAP
#KEYMAP_CORRECTIONS=PHY_KEYMAP_CORRECTIONS
#FONT=PHY_FONT
#LEGACY_CHARSET=PHY_LEGACY_CHARSET
EOF
    sed -e "s|PHY_UNICODE|${PHY_UNICODE}|" \
        -e "s|PHY_KEYMAP_CORRECTIONS|${PHY_KEYMAP_CORRECTIONS}|" \
        -e "s|PHY_KEYMAP|${PHY_KEYMAP}|" \
        -e "s|PHY_FONT|${PHY_FONT}|" \
        -e "s|PHY_LEGACY_CHARSET|${PHY_LEGACY_CHARSET}|" \
        -e "s|PHY_UTC|${PHY_UTC}|" \
        -e "s|PHY_HOSTNAME|${PHY_HOSTNAME}|" \
        -i /etc/sysconfig/rc.site


    cat > /etc/sysconfig/clock << EOF
UTC=$PHY_UTC
CLOCKPARAMS=
EOF

    cat > /etc/sysconfig/console << "EOF"
UNICODE=PHY_UNICODE
KEYMAP=PHY_KEYMAP
KEYMAP_CORRECTIONS=PHY_KEYMAP_CORRECTIONS
FONT=PHY_FONT
LEGACY_CHARSET=PHY_LEGACY_CHARSET
EOF
    sed -e "s|PHY_UNICODE|${PHY_UNICODE}|" \
        -e "s|PHY_KEYMAP_CORRECTIONS|${PHY_KEYMAP_CORRECTIONS}|" \
        -e "s|PHY_KEYMAP|${PHY_KEYMAP}|" \
        -e "s|PHY_FONT|${PHY_FONT}|" \
        -e "s|PHY_LEGACY_CHARSET|${PHY_LEGACY_CHARSET}|" \
        -i /etc/sysconfig/console
}
