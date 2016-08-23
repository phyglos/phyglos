#!/bin/bash

build_compile()
{
    sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl

    cat > config.cache <<"EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I$BANDIT_BUILDER_DIR/include"
EOF

    ./configure                 \
	--prefix=/usr           \
        --bindir=/sbin          \
        --sbindir=/sbin         \
        --libdir=/usr/lib       \
        --sysconfdir=/etc       \
        --libexecdir=/lib       \
        --with-rootprefix=      \
        --with-rootlibdir=/lib  \
        --enable-manpages       \
        --disable-static        \
        --config-cache

    LIBRARY_PATH=$BANDIT_BUILDER_DIR/lib \
    make

    tar -xvf $BUILD_SOURCES/udev-lfs-20140408.tar.bz2
    make -f udev-lfs-20140408/Makefile.lfs install
}

build_test_level=3
build_test()
{
    bandit_mkdir /lib/udev/rules.d
    bandit_mkdir /etc/udev/rules.d

    make LD_LIBRARY_PATH=$BANDIT_BUILDER_DIR/lib check 
}

build_pack()
{
    bandit_mkdir /lib/udev/rules.d
    bandit_mkdir /etc/udev/rules.d

    make DESTDIR=$BUILD_PACK LD_LIBRARY_PATH=$BANDIT_BUILDER_DIR/lib install

    make -f udev-lfs-20140408/Makefile.lfs DESTDIR=$BUILD_PACK install
}

install_setup()
{
    # Create initial hardware database
    LD_LIBRARY_PATH=$BANDIT_BUILDER_DIR/lib udevadm hwdb --update
}
