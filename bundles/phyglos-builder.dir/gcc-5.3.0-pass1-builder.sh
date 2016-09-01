#!/bin/bash

build_compile()
{
    tar -xf $BUILD_SOURCES/mpfr-3.1.3.tar.xz
    mv -v mpfr-3.1.3 mpfr
    tar -xf $BUILD_SOURCES/gmp-6.1.0.tar.xz
    mv -v gmp-6.1.0 gmp
    tar -xf $BUILD_SOURCES/mpc-1.0.3.tar.gz
    mv -v mpc-1.0.3 mpc

    for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
    do
	cp -uv $file{,.orig}
	sed -e "s@/lib\(64\)\?\(32\)\?/ld@$BANDIT_BUILDER_DIR&@g" \
	    -e "s@/usr@$BANDIT_BUILDER_DIR@g" $file.orig > $file
	echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"$BANDIT_BUILDER_DIR/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\" " >> $file
	touch $file.orig
    done

    mkdir -v gcc-build
    cd gcc-build

    ../configure                                                    \
        --target=$BANDIT_BUILDER_TRIPLET                               \
        --prefix=$BANDIT_BUILDER_DIR                                \
        --with-glibc-version=2.11                                   \
        --with-sysroot=$BANDIT_HOST_TGT_MNT                         \
        --with-newlib                                               \
        --without-headers                                           \
        --with-local-prefix=$BANDIT_BUILDER_DIR                     \
        --with-native-system-header-dir=$BANDIT_BUILDER_DIR/include \
        --disable-nls                                    \
        --disable-shared                                 \
        --disable-multilib                               \
        --disable-decimal-float                          \
        --disable-threads                                \
        --disable-libatomic                              \
        --disable-libgomp                                \
        --disable-libquadmath                            \
        --disable-libssp                                 \
        --disable-libvtv                                 \
        --disable-libstdcxx                              \
        --enable-languages=c,c++                         

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
