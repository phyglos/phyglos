#!/bin/bash 

export PHY_KERNEL_SRC=linux-$PHY_KERNEL_VER
export PHY_KERNEL_CFG=$PHY_KERNEL_SRC-$PHY_KERNEL_ARCH-$PHY_KERNEL_HW

build_config()
{
    make mrproper

    if [ ! -e $BUILD_ETC/$PHY_KERNEL_CFG.config ]; then
	echo "Copying a new .config file..."
	bandit_mkdir $BUILD_ETC
	cp -v $BUILD_SOURCES/$PHY_KERNEL_CFG.config $BUILD_ETC/$PHY_KERNEL_CFG.config
    else
	echo "Using present .config file from BANDIT/etc directory..."
    fi
    cp -v $BUILD_ETC/$PHY_KERNEL_CFG.config .config

    make menuconfig 

    cp -v $BUILD_ETC/$PHY_KERNEL_CFG.config $BUILD_ETC/$PHY_KERNEL_CFG.config.old
    cp -v .config $BUILD_ETC/$PHY_KERNEL_CFG.config
    echo
}

build_compile()
{
    make mrproper

    cp -v $BUILD_ETC/$PHY_KERNEL_CFG.config .config

    make bzImage
    make modules
}

build_pack()
{
    # Pack the kernel
    bandit_mkdir $BUILD_PACK/boot
    cp -v arch/$PHY_KERNEL_ARCH/boot/bzImage \
	             $BUILD_PACK/boot/vmlinuz-$PHY_KERNEL_VER-$PHY_KERNEL_ARCH-$PHY_KERNEL_HW
    cp -v System.map $BUILD_PACK/boot/System.map-$PHY_KERNEL_CFG
    cp -v .config    $BUILD_PACK/boot/$PHY_KERNEL_CFG.config

    # Pack the modules
    bandit_mkdir $BUILD_PACK/lib/modules
    bandit_mkdir $BUILD_PACK/lib/firmware
    make INSTALL_MOD_PATH="$BUILD_PACK" modules_install

    bandit_mkdir $BUILD_PACK/etc
    install -v -m755 -d $BUILD_PACK/etc/modprobe.d
    cat > $BUILD_PACK/etc/modprobe.d/usb.conf <<EOF
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

    # Pack documentation
    bandit_mkdir $BUILD_PACK/usr/share/doc
    install -d $BUILD_PACK/usr/share/doc/linux-4.4.2
    cp -r Documentation/* $BUILD_PACK/usr/share/doc/linux-4.4.2
}

