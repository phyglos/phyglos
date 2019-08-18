#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/coreutils-8.30-i18n-1.patch

    sed -i '/tests\/misc\/sort.pl/ d' Makefile.in

    autoreconf -fiv
    FORCE_UNSAFE_CONFIGURE=1 \
    ./configure              \
	--prefix=/usr        \
        --enable-no-install-program=kill,uptime

    FORCE_UNSAFE_CONFIGURE=1 \
    make
}

build_test_level=1
build_test()
{
    make NON_ROOT_USERNAME=nobody check-root

    echo "dummy:x:1000:nobody" >> /etc/group
    chown -Rv nobody . 
    su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check" 
    sed -i '/dummy/d' /etc/group
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm}        $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/{rmdir,stty,sync,true,uname,test,[}        $BUILD_PACK/bin
    mv -v $BUILD_PACK/usr/bin/{head,sleep,nice,touch}                    $BUILD_PACK/bin

    bandit_mkdir $BUILD_PACK/usr/sbin
    mv -v $BUILD_PACK/usr/bin/chroot $BUILD_PACK/usr/sbin

    bandit_mkdir $BUILD_PACK/usr/share/man/man8
    mv -v $BUILD_PACK/usr/share/man/man1/chroot.1 $BUILD_PACK/usr/share/man/man8/chroot.8
    sed -i s/\"1\"/\"8\"/1 $BUILD_PACK/usr/share/man/man8/chroot.8
}
