#!/bin/bash

build_compile()
{
#    case $(uname -m) in
#        x86_64)
#            sed -e '/m64=/s/lib64/lib/' \
#                -i.orig gcc/config/i386/t-linux64
#            ;;
#    esac

    rm -vf /usr/lib/gcc
    
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
    rm ../gcc/testsuite/g++.dg/pr83239.C

    chown -R nobody . 
    su nobody -s /bin/bash -c "PATH=$PATH make -k check 2>&1"
    
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

    install -v -dm755 $BUILD_PACK/usr/lib/bfd-plugins
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.3.0/liblto_plugin.so $BUILD_PACK/usr/lib/bfd-plugins/

    mkdir -pv $BUILD_PACK/usr/share/gdb/auto-load/usr/lib
    mv -v $BUILD_PACK/usr/lib*/*gdb.py $BUILD_PACK/usr/share/gdb/auto-load/usr/lib
}

install_verify()
{
    bandit_log "Checking the new system C/C++ compiler..."

    # Ensure testing the new compiler with full path
    echo 'int main(){}' > dummy.c
    /usr/bin/cc dummy.c -v -Wl,--verbose &> dummy.log

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
    grep -B4 '^End of search list' dummy.log
    echo "Compare lines above with:"
    case $BANDIT_TARGET_ARCH in
	i?86)
	    echo " /usr/lib/gcc/x86-pc-linux-gnu/8.3.0/include"
	    echo " /usr/local/include"
	    echo " /usr/lib/gcc/x86-pc-linux-gnu/8.3.0/include-fixed"
	    echo " /usr/include"
	    echo "End of search list."
	    ;;
	x86_64)
	    echo " /usr/lib/gcc/x86_64-pc-linux-gnu/8.3.0/include"
	    echo " /usr/local/include"
	    echo " /usr/lib/gcc/x86_64-pc-linux-gnu/8.3.0/include-fixed"
	    echo " /usr/include"
	    echo "End of search list."
	    ;;
    esac
    echo

    echo "CHECK: Search paths"
    grep 'SEARCH.*/usr/lib' dummy.log | sed 's|; |\n|g'
    echo "Compare lines above with (ignore the "linux-gnu" lines):"
    case $BANDIT_TARGET_ARCH in
	i?86)
            echo 'SEARCH_DIR("/usr/local/lib")'
            echo 'SEARCH_DIR("/lib")'
            echo 'SEARCH_DIR("/usr/lib");'
	    ;;
	x86_64)
            echo 'SEARCH_DIR("/usr/local/lib64")'
            echo 'SEARCH_DIR("/lib64")'
            echo 'SEARCH_DIR("/usr/lib64")'
            echo 'SEARCH_DIR("/usr/local/lib")'
            echo 'SEARCH_DIR("/lib")'
            echo 'SEARCH_DIR("/usr/lib");'
	    ;;
    esac
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
