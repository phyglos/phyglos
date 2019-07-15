#!/bin/bash

build_compile()
{
    sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
    sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
    echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

    sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in
    
    ./configure        \
	--prefix=/usr  \
	--localstatedir=/var/lib/locate

    make
}

build_test_level=3
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    # Move 'find' to /bin due to LFS-scripts dependencies
    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/find $BUILD_PACK/bin
    sed -i 's|find:=${BINDIR}|find:=/bin|' $BUILD_PACK/usr/bin/updatedb

    # Set environment PRUNE* vars to limit some searches for updatedb script
    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/updatedb.sh <<"EOF" 
export PRUNE_BIND_MOUNTS="1"
export PRUNENAMES=".bzr .git .hg .svn"
export PRUNEPATHS="/media /mnt /tmp /usr/tmp /var/spool /var/tmp"
export PRUNEFS="afs autofs binfmt_misc cifs coda devfs devpts ftpfs fuse.glusterfs fuse.sshfs ecryptfs fusesmb devtmpfs lustre_lite mfs ncpfs NFS nfs nfs4 proc rpc_pipefs shfsiso9660 smbfs sysfs tmpfs usbfs udf"
EOF
}
