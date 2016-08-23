#/bin/bash 

build_compile()
{
    sed -e '/int.*old_desc_blocks/s/int/blk64_t/' \
	-e '/if (old_desc_blocks/s/super->s_first_meta_bg/desc_blocks/' \
	-i lib/ext2fs/closefs.c

    mkdir -v build
    cd build

    LIBS=-L/$BANDIT_BUILDER_DIR/lib                    \
    CFLAGS=-I/$BANDIT_BUILDER_DIR/include              \
    PKG_CONFIG_PATH=/$BANDIT_BUILDER_DIR/lib/pkgconfig \
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
    ln -sfv /$BANDIT_BUILDER_DIR/lib/lib{blk,uu}id.so.1 lib

    make LD_LIBRARY_PATH=/$BANDIT_BUILDER_DIR/lib check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
    make DESTDIR=$BUILD_PACK install-libs

    chmod -v u+w $BUILD_PACK/usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

    makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info $BUILD_PACK/usr/share/info
    install-info --dir-file=/usr/share/info/dir $BUILD_PACK/usr/share/info/com_err.info
}

install_unpack()
{
    yes | gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
}
