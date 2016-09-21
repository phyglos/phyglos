#/bin/bash 

build_compile()
{
    ./configure          \
	--prefix=/usr    \
	--disable-static \
	--enable-dl      \
	--with-gmp

    make              
}

build_test_level=0
build_test()
{
    make check
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/glpk-4.60
    cp doc/glpk.pdf $BUILD_PACK/usr/share/doc/glpk-4.60
    cp doc/gmpl.pdf $BUILD_PACK/usr/share/doc/glpk-4.60
}
