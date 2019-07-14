#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    ../configure                                    \
	--prefix=$BANDIT_BUILDER_DIR                \
	--host=$BANDIT_BUILDER_TRIPLET              \
	--build=$(../scripts/config.guess)          \
	--enable-kernel=3.2                         \
	--with-headers=$BANDIT_BUILDER_DIR/include

    make -j1
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}

install_verify()
{
    bandit_log "Checking for a working compiler..."

    echo "CHECK: Compiling and linking"

    echo 'int main(){}' > dummy.c
    $BANDIT_BUILDER_TRIPLET-gcc dummy.c

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
