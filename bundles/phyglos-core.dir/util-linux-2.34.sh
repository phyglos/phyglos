#!/bin/bash 

build_compile()
{
    mkdir -pv /var/lib/hwclock
    
    ADJTIME_PATH=/var/lib/hwclock/adjtime \
    ./configure              \
        --disable-chfn-chsh  \
        --disable-login      \
        --disable-nologin    \
        --disable-su         \
        --disable-setpriv    \
        --disable-runuser    \
        --disable-pylibmount \
        --disable-static     \
        --without-python     \
        --without-systemd    \
        --without-systemdsystemunitdir \
        --docdir=/usr/share/doc/util-linux-2.34

    make
}

build_test_level=3
build_test()
{
    chown -Rv nobody .
    su nobody -s /bin/bash -c "PATH=$PATH make -k check"
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
