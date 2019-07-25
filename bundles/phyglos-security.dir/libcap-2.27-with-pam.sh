#!/bin/bash

build_compile()
{
    make -C pam_cap
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/lib/security
    install -v -m755 pam_cap/pam_cap.so $BUILD_PACK/lib/security

    bandit_mkdir $BUILD_PACK/etc/security
    install -v -m644 pam_cap/capability.conf $BUILD_PACK/etc/security
}

