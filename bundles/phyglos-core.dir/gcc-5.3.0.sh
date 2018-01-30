#!/bin/bash

build_compile()
{
    mkdir -v build
    cd build

    SED=sed                         \
    ../configure                    \
	--prefix=/usr               \
	--enable-languages=c,c++    \
	--disable-multilib          \
	--disable-bootstrap         \
	--with-system-zlib

    make
}

build_test_level=1
build_test()
{
    ulimit -s 32768
    make -k check

    bandit_log "Summary of tests results..."

    ../contrib/test_summary | grep -A7 Summ
    echo
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    mkdir -pv $BUILD_PACK/lib
    ln -sv ../usr/bin/cpp $BUILD_PACK/lib
    ln -sv gcc $BUILD_PACK/usr/bin/cc

    install -dm755 $BUILD_PACK/usr/lib/bfd-plugins
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/5.3.0/liblto_plugin.so $BUILD_PACK/usr/lib/bfd-plugins/

    mkdir -pv $BUILD_PACK/usr/share/gdb/auto-load/usr/lib
    mv -v $BUILD_PACK/usr/lib*/*gdb.py $BUILD_PACK/usr/share/gdb/auto-load/usr/lib
}

install_verify()
{
    bandit_log "Checking the new system C/C++ compiler..."

    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log

    echo "CHECK: Compiling and linking"
    readelf -l a.out | grep ': /lib'
    echo "Compare line above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "      [Requesting program interpreter: /lib/ld-linux.so.2]"
	    ;;
	x86_64)
	    echo "      [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
	    ;;
    esac
    echo

    echo "CHECK: C runtime files"
    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
    echo "Compare lines above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "/usr/lib/crt1.o succeeded"
	    echo "/usr/lib/crti.o succeeded"
	    echo "/usr/lib/crtn.o succeeded"
	    ;;
	x86_64)
	    echo "/usr/lib64/crt1.o succeeded"
	    echo "/usr/lib64/crti.o succeeded"
	    echo "/usr/lib64/crtn.o succeeded"
	    ;;
    esac
    echo

    echo "CHECK: Search for C header files"
    grep -B4 '^ /usr/include' dummy.log
    echo "Compare lines above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "#include <...> search starts here:"
	    echo " /usr/lib/gcc/.../include"
	    echo " /usr/lib/gcc/.../include-fixed"
	    echo " /usr/local/include"
	    echo " /usr/include"
	    ;;
	x86_64)
	    echo "#include <...> search starts here:"
	    echo " /usr/lib/gcc/.../include"
	    echo " /usr/lib/gcc/.../include-fixed"
	    echo " /usr/local/include"
	    echo " /usr/include"
	    ;;
    esac
    echo

    echo "CHECK: Search paths"
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    echo "Compare lines above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "SEARCH_DIR(\"/usr/local/lib32\")"
	    echo "SEARCH_DIR(\"/lib32\")"
	    echo "SEARCH_DIR(\"/usr/lib32\")"
	    echo "SEARCH_DIR(\"/usr/local/lib\")"
	    echo "SEARCH_DIR(\"/lib\")"
	    echo "SEARCH_DIR(\"/usr/lib\");"
	    ;;
	x86_64)
	    echo "SEARCH_DIR(\"/usr/local/lib64\")"
	    echo "SEARCH_DIR(\"/lib64\")"
	    echo "SEARCH_DIR(\"/usr/lib64\")"
	    echo "SEARCH_DIR(\"/usr/local/lib\")"
	    echo "SEARCH_DIR(\"/lib\")"
	    echo "SEARCH_DIR(\"/usr/lib\");"
	    ;;
    esac
    echo "Ignore extra lines with '-linux-gnu'"
    echo
    
    echo "CHECK: C library"
    grep "/lib.*/libc.so.6 " dummy.log
    echo "Compare line above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "attempt to open /lib/libc.so.6 succeeded"
	    ;;
	x86_64)
	    echo "attempt to open /lib64/libc.so.6 succeeded"
	    ;;
    esac
    echo

    echo "CHECK: dynamic linker"
    grep found dummy.log
    echo "Compare line above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo "found ld-linux.so.2 at /lib/ld-linux.so.2"
	    ;;
	x86_64)
	    echo "found ld-linux-x86-64.so.2 at /lib64/ld-linux-x86-64.so.2"
	    ;;
    esac
    echo

    rm -v dummy.c a.out dummy.log
}
