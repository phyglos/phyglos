#!/bin/bash

build_compile()
{
    ./configure                  \
	--prefix=/usr            \
        --disable-static         \
        INIT_D_PATH=/tmp/init.d

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    # Remove unneeded scripts
    rm -rf  $BUILD_PACK/tmp
    
    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libfuse.so.* $BUILD_PACK/lib 
    ln -sfv ../../lib/libfuse.so.2.9.7     $BUILD_PACK/usr/lib/libfuse.so 
    
    bandit_mkdir $BUILD_PACK/usr/share/doc/fuse-2.9.7 
    install -v -m644 doc/{how-fuse-works,kernel.txt} $BUILD_PACK/usr/share/doc/fuse-2.9.7
    
    bandit_mkdir $BUILD_PACK/etc
    cat > $BUILD_PACK/etc/fuse.conf << "EOF"
# Set the maximum number of FUSE mounts allowed to non-root users.
# The default is 1000.
#
#mount_max = 1000

# Allow non-root users to specify the 'allow_other' or 'allow_root'
# mount options.
#
#user_allow_other
EOF

}

