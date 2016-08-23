#!/bin/bash

build_compile()
{
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
    sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
    sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c

    ./configure               \
	--prefix=/usr         \
        --bindir=/bin         \
        --disable-static      \
        --libexecdir=/usr/lib

    make
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/lib

    make DIST_ROOT=$BUILD_PACK install install-dev install-lib

    chmod -v 755 $BUILD_PACK/usr/lib/libacl.so

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libacl.so.* $BUILD_PACK/lib

    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libacl.so) $BUILD_PACK/usr/lib/libacl.so
}
