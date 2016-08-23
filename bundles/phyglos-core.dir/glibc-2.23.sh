#!/bin/bash 

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/glibc-2.23-fhs-1.patch

    mkdir -v build
    cd build

    ../configure               \
	--prefix=/usr          \
	--disable-profile      \
	--enable-kernel=2.6.32 \
	--enable-obsolete-rpc

    make
}

build_test_level=1
build_test()
{
    make check
}

build_pack()
{

    bandit_mkdir $BUILD_PACK/etc
    touch $BUILD_PACK/etc/ld.so.conf

    make DESTDIR=$BUILD_PACK install

    cp -v ../nscd/nscd.conf $BUILD_PACK/etc/nscd.conf
    bandit_mkdir $BUILD_PACK/var/cache/nscd

    cat > $BUILD_PACK/etc/nsswitch.conf << "EOF"
passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files
EOF

    cat > $BUILD_PACK/etc/ld.so.conf << "EOF"
/usr/local/lib
/opt/lib

include /etc/ld.so.conf.d/*.conf
EOF
    bandit_mkdir $BUILD_PACK/etc/ld.so.conf.d

    bandit_mkdir $BUILD_PACK/usr/lib/locale
    #localedef -i en_US -f UTF-8  $BUILD_PACK/usr/lib/locale/en_US.UTF-8
}

