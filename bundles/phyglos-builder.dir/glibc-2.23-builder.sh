#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    ../configure                                      \
	--host=$BANDIT_BUILDER_TRIPLET                      \
	--build=$(../scripts/config.guess)            \
	--prefix=$BANDIT_BUILDER_DIR                     \
	--disable-profile                             \
	--enable-kernel=2.6.32                        \
	--enable-obsolote-rpc                         \
	--with-headers=$BANDIT_BUILDER_DIR/include       \
	libc_cv_forced_unwind=yes                     \
	libc_cv_ctors_header=yes                      \
	libc_cv_c_cleanup=yes

    make -j1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

install_verify()
{
    bandit_log "Checking for a working compiler..."

    echo 'int main(){}' > dummy.c
    $BANDIT_BUILDER_TRIPLET-gcc dummy.c

    echo
    readelf -l a.out | grep ": $BANDIT_BUILDER_DIR"
    echo "Compare line above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "      [Requesting program interpreter: $BANDIT_BUILDER_DIR/lib/ld-linux.so.2]"
	    ;;
	x86_64)
	    echo "      [Requesting program interpreter: $BANDIT_BUILDER_DIR/lib64/ld-linux-x86-64.so.2]"
	    ;;
    esac
    echo

    rm -v dummy.c a.out

}
