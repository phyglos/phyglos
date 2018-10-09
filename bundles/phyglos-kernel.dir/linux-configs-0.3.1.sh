#!/bin/bash 

PHY_KERNEL_SRC=linux-$PHY_KERNEL_VER
PHY_KERNEL_CFG=$PHY_KERNEL_SRC-$PHY_KERNEL_ARCH-$PHY_KERNEL_HW

build_config()
{
    echo "Working with linux-configs/$PHY_KERNEL_CFG.config:" 
    if [ -e /boot/$PHY_KERNEL_CFG.config ]; then
	echo "Using existing .config file from /boot directory...skipping"
    else
	echo "No .config file found in from /boot directory..."
	if [ -e /var/lib/phyglos/linux-configs/$PHY_KERNEL_CFG.config ]; then
	    echo "Copying the .config file from linux-configs package to the /boot directory..."
	    bandit_mkdir /boot
	    cp -v /var/lib/phyglos/linux-configs/$PHY_KERNEL_CFG.config /boot/$PHY_KERNEL_CFG.config
	else
	    echo "Creating the /boot directory and copying the .config file..."
	    bandit_mkdir /boot
	    cp -v $PHY_KERNEL_CFG.config /boot/$PHY_KERNEL_CFG.config
	fi
    fi  
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/var/lib/phyglos/linux-configs
    cp -v linux-$PHY_KERNEL_VER-$PHY_KERNEL_ARCH-* $BUILD_PACK/var/lib/phyglos/linux-configs
}

