#!/bin/sh

script_run()
{
    bandit_log "Adjusting BUILDER to use the new C library..."

    mv -v $BANDIT_BUILDER_DIR/bin/{ld,ld-old}
    mv -v $BANDIT_BUILDER_DIR/$BANDIT_TARGET_ARCH-pc-linux-gnu/bin/{ld,ld-old}

    mv -v $BANDIT_BUILDER_DIR/bin/{ld-new,ld}
    ln -sv $BANDIT_BUILDER_DIR/bin/ld $BANDIT_BUILDER_DIR/$BANDIT_TARGET_ARCH-pc-linux-gnu/bin/ld

    gcc -dumpspecs | sed -e "s@$BANDIT_BUILDER_DIR@@g"                          \
   	                 -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
	                 -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}'        \
                       > `dirname $(gcc --print-libgcc-file-name)`/specs
}

script_verify()
{
    bandit_log "Checking the new C/C++ toolchain..."

    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log

    echo "CHECK: Compiling and linking"
    readelf -l a.out | grep ': /lib'
    echo "Compare lines above with:"
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
    grep -B1 '^ /usr/include' dummy.log
    echo "Compare lines above with:"
    echo "#include <...> search starts here:"
    echo " /usr/include"
    echo

    echo "CHECK: Search paths"
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    echo "Compare lines above with:"
    echo "SEARCH_DIR(\"/usr/lib\")"
    echo "SEARCH_DIR(\"/lib\");"
    echo "Ignore extra lines with '-linux-gnu'"
    echo 

    echo "CHECK: C library"
    grep "/lib.*/libc.so.6 " dummy.log
    echo "Compare lines above with:"
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
    echo "Compare lines above with:"
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
