#/bin/bash 

build_compile()
{
    mkdir -v build
    cd build

    ../configure                \
        --prefix=/usr           \
        --bindir=/bin           \
        --with-root-prefix=""   \
        --enable-elf-shlibs     \
        --disable-libblkid      \
        --disable-libuuid       \
        --disable-uuidd         \
        --disable-fsck

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
    
    make DESTDIR=$BUILD_PACK install-libs
    chmod -v u+w $BUILD_PACK/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

    makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info $BUILD_PACK/usr/share/info
    install-info --dir-file=/usr/share/info/dir $BUILD_PACK/usr/share/info/com_err.info
}

install_setup()
{
    yes | gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
}
