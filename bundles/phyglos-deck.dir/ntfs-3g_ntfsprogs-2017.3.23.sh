#!/bin/bash

build_compile()
{
    ./configure              \
	--prefix=/usr        \
        --disable-static     \
        --with-fuse=internal
    
    make
}

build_pack()
{
    # Make directory to let 'make' move libraries 
    bandit_mkdir $BUILD_PACK/lib
    
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/sbin
    ln -sv ../bin/ntfs-3g $BUILD_PACK/sbin/mount.ntfs

    bandit_mkdir $BUILD_PACK/usr/share/man/man8
    ln -sv ntfs-3g.8 $BUILD_PACK/usr/share/man/man8/mount.ntfs.8
}
