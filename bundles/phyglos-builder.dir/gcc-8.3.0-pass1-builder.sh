#!/bin/bash

build_compile()
{
    tar -xf $BUILD_SOURCES/mpfr-4.0.2.tar.xz
    mv -v mpfr-4.0.2 mpfr
    tar -xf $BUILD_SOURCES/gmp-6.1.2.tar.xz
    mv -v gmp-6.1.2 gmp
    tar -xf $BUILD_SOURCES/mpc-1.1.0.tar.gz
    mv -v mpc-1.1.0 mpc

    for file in gcc/config/{linux,i386/linux{,64}}.h
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

    case $(uname -m) in
        x86_64)
            sed -e '/m64=/s/lib64/lib/' \
                -i.orig gcc/config/i386/t-linux64
            ;;
    esac
    
    mkdir -v build
    cd build

    ../configure                                                    \
        --prefix=$BANDIT_BUILDER_DIR                                \
        --with-glibc-version=2.11                                   \
        --with-sysroot=$BANDIT_HOST_TGT_MNT                         \
        --target=$BANDIT_BUILDER_TRIPLET                            \
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
        --disable-libmpx                                 \
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
