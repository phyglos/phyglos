#!/bin/bash 

export PHY_KERNEL_SRC=linux-$PHY_KERNEL_VER
export PHY_KERNEL_CFG=$PHY_KERNEL_SRC-$PHY_KERNEL_ARCH-$PHY_KERNEL_HW

_get_config_file()
{
    if [ ! -e /boot/$PHY_KERNEL_CFG.config ]; then
	if [ -e $BUILD_SOURCES/$PHY_KERNEL_CFG.config ]; then
	    echo "Copying a new .config file..."
	    cp -v $BUILD_SOURCES/$PHY_KERNEL_CFG.config /boot/$PHY_KERNEL_CFG.config
	else
	    echo "Creating a defaulf .config file..."
	    make defconfig
	    cp -v .config /boot/$PHY_KERNEL_CFG.config 
	fi
    else
	echo "Using .config file from /boot directory..."
    fi
    cp -v /boot/$PHY_KERNEL_CFG.config .config
}

build_config()
{
    make mrproper  
    _get_config_file

    make menuconfig 

    cp -v /boot/$PHY_KERNEL_CFG.config /boot/$PHY_KERNEL_CFG.config.last
    cp -v .config /boot/$PHY_KERNEL_CFG.config
    echo
}

build_compile()
{
    make mrproper
    _get_config_file

    make bzImage
    make modules
}

build_pack()
{
    # Pack the kernel
    bandit_log "Installing the kernel..."
    bandit_mkdir $BUILD_PACK/boot
    cp -v arch/$PHY_KERNEL_ARCH/boot/bzImage \
	             $BUILD_PACK/boot/vmlinuz-$PHY_KERNEL_VER-$PHY_KERNEL_ARCH-$PHY_KERNEL_HW
    cp -v System.map $BUILD_PACK/boot/System.map-$PHY_KERNEL_CFG
    cp -v .config    $BUILD_PACK/boot/$PHY_KERNEL_CFG.config

    # Pack kernel modules and firmware
    bandit_log "Installing modules..."
    bandit_mkdir $BUILD_PACK/lib/modules
    bandit_mkdir $BUILD_PACK/lib/firmware
    make INSTALL_MOD_PATH="$BUILD_PACK" modules_install

    # Configure USB modules
    bandit_mkdir $BUILD_PACK/etc
    install -v -m755 -d $BUILD_PACK/etc/modprobe.d
    cat > $BUILD_PACK/etc/modprobe.d/usb.conf << EOF
# Load USB modules in correct order
install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true
EOF

    # Pack a copy of the kernel build directory 
    if [ $PHY_KERNEL_KEEP_BUILD = "yes" ]; then
	bandit_log "Saving build tree..."
	rm -rf $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/build

	bandit_mkdir $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/build
	cp -R * $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/build

	# Make a link from build to sources if they are not saved later
	if [ $PHY_KERNEL_KEEP_SOURCE != "yes" ]; then
	    rm -rf $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/source
	    ln -s /lib/modules/$PHY_KERNEL_VER/build $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/source
	fi
    fi
    
    # Pack a clean copy of the kernel source directory 
    if [ $PHY_KERNEL_KEEP_SOURCE = "yes" ]; then
	# Clean source tree again
	bandit_log "Cleaning source tree..."
	rm -rf $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/source
	make clean
	
	bandit_log "Saving source tree..."
	bandit_mkdir $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/source
	cp -R * $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/source	
    fi

    # Pack documentation
    bandit_mkdir $BUILD_PACK/usr/share/doc/$PHY_KERNEL_SRC
    cp -r Documentation/* $BUILD_PACK/usr/share/doc/$PHY_KERNEL_SRC
    rm -rf $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/source/Documentation
    rm -rf $BUILD_PACK/lib/modules/$PHY_KERNEL_VER/build/Documentation
}

