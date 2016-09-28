#!/bin/bash

build_compile()
{
    # Remove internal copies of system libraries
    rm -rf freetype jpeg lcms2 libpng zlib
    
    ./configure                \
	--prefix=/usr          \
        --enable-dynamic       \
	--with-system-libtiff  \
	--disable-cups         \
	--disable-compile-inits 

    make so
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    make DESTDIR=$BUILD_PACK soinstall
    
    bandit_mkdir $BUILD_PACK/usr/include/ghostscript
    install -m644 base/*.h $BUILD_PACK/usr/include/ghostscript
    ln -s ghostscript $BUILD_PACK/usr/include/ps

    bandit_mkdir $BUILD_PACK/usr/share/doc/ghostscript-9.18
    ln -sfvn ../ghostscript/9.18/doc $BUILD_PACK/usr/share/doc/ghostscript-9.19

    bandit_mkdir $BUILD_PACK/usr/share/ghostscript
    bandit_pushd $BUILD_PACK/usr/share/ghostscript
    tar -xf $BUILD_SOURCES/ghostscript-fonts-std-8.11.tar.gz --no-same-owner
    tar -xf $BUILD_SOURCES/gnu-gs-fonts-other-6.0.tar.gz     --no-same-owner
    bandit_popd
}

install_setup()
{
    fc-cache -v /usr/share/ghostscript/fonts/
}
