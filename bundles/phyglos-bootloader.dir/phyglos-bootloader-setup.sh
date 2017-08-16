#!/bin/bash

script_run()
{
    local KERNEL=$PHY_KERNEL_VER-$PHY_KERNEL_ARCH-$PHY_KERNEL_HW

    bandit_mkdir /boot/grub
    cat > /boot/grub/grub.cfg <<EOF
set default=0
set timeout=2

insmod $PHY_BOOT_ROOT_TYPE

menuentry "phyglos $BUILD_RELEASE, linux-$KERNEL" {
  set root=$PHY_BOOT_ROOT_DISK
  linux /boot/vmlinuz-$KERNEL root=$PHY_BOOT_ROOT_PART $PHY_BOOT_LINUX_CMDLINE ro
}
EOF

}

script_test_level=2
script_test()
{
    bandit_msg "Checking grub.cfg..."

    grub-script-check -v /boot/grub/grub.cfg
}
