#!/bin/bash

build_compile()
{
    cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
	`dirname $($BANDIT_BUILDER_TRIPLET-gcc -print-libgcc-file-name)`/include-fixed/limits.h

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
    
    tar -xf $BUILD_SOURCES/mpfr-4.0.2.tar.xz
    mv -v mpfr-4.0.2 mpfr
    tar -xf $BUILD_SOURCES/gmp-6.1.2.tar.xz
    mv -v gmp-6.1.2 gmp
    tar -xf $BUILD_SOURCES/mpc-1.1.0.tar.gz
    mv -v mpc-1.1.0 mpc

    mkdir -v build
    cd build

    CC=$BANDIT_BUILDER_TRIPLET-gcc                                  \
    CXX=$BANDIT_BUILDER_TRIPLET-g++                                 \
    AR=$BANDIT_BUILDER_TRIPLET-ar                                   \
    RANLIB=$BANDIT_BUILDER_TRIPLET-ranlib                           \
    ../configure                                                    \
        --prefix=$BANDIT_BUILDER_DIR                                \
        --with-local-prefix=$BANDIT_BUILDER_DIR                     \
        --with-native-system-header-dir=$BANDIT_BUILDER_DIR/include \
        --enable-languages=c,c++                                    \
        --disable-libstdcxx-pch                                     \
        --disable-multilib                                          \
        --disable-bootstrap                                         \
        --disable-libgomp                                

    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ln -sv gcc $BUILD_PACK$BANDIT_BUILDER_DIR/bin/cc
}

install_verify()
{
    bandit_log "Checking for a working compiler..."

    echo 'void main(){}' > dummy.c
    cc dummy.c

    echo "CHECK: Compiling and linking"
    readelf -l a.out | grep ": $BANDIT_BUILDER_DIR"
    echo "Compare line above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
            echo "      [Requesting program interpreter: $BANDIT_BUILDER_DIR/lib/ld-linux.so.2]"
	    ;;
	x86_64)
            echo "      [Requesting program interpreter: $BANDIT_BUILDER_DIR/lib64/ld-linux-x86-64.so.2]"
	    ;;
    esac
    echo

    rm -v dummy.c a.out
}
