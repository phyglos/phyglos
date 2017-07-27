#!/bin/bash

build_compile()
{
    ./configure                \
	--prefix=/usr          \
        --sbindir=/sbin        \
        --sysconfdir=/etc      \
        --disable-efiemu       \
        --disable-werror

    make 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

install_setup()
{
    # Exit if disk to install is set to 'none'
    [ "$PHY_BOOT_DISK" != "none" ] || exit 0

    bandit_log "Installing the bootloader in $PHY_BOOT_DISK..."

    grub-install $PHY_BOOT_DISK
}
