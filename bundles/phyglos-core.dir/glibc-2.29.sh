#!/bin/bash 

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/glibc-2.29-fhs-1.patch

    case $(uname -m) in
        i?86)   ln -sfv ld-linux.so.2 /lib/ld-lsb.so.3
                ;;
        x86_64) ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64
                ln -sfv ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
                ;;
    esac

    mkdir build
    cd build
    
    CC="gcc -ffile-prefix-map=/tools=/usr" \
    libc_cv_slibdir=/lib                   \
      ../configure                         \
        --prefix=/usr                      \
        --disable-werror                   \
        --enable-kernel=3.2                \
        --enable-stack-protector=strong    \
        --with-headers=/usr/include
    
    make
}

build_test_level=1
build_test()
{
    case $(uname -m) in
        i?86)   ln -sfnv $PWD/elf/ld-linux.so.2        /lib ;;
        x86_64) ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib ;;
    esac
    
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
}

