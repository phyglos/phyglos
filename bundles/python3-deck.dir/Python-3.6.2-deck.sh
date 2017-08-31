#!/bin/bash

build_compile()
{
    CXX="/usr/bin/g++"      \
    ./configure             \
	--prefix=/usr       \
	--enable-shared     \
	--with-system-expat \
	--with-system-ffi   \
	--with-ensurepip=yes
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.6m.so
    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.so

    bandit_mkdir $BUILD_PACK/usr/share/doc/python-3.6.2/
    install -dm755 $BUILD_PACK/usr/share/doc/python-3.6.2/html
    tar -xvf $BUILD_SOURCES/python-3.6.2-docs-html.tar.bz2 \
	-C $BUILD_PACK/usr/share/doc/python-3.6.2/html \
	--strip-components=1  \
	--no-same-owner       \
	--no-same-permissions
    ln -svfn python-3.6.2 $BUILD_PACK/usr/share/doc/python-3

    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/python3.sh <<EOF
export PYTHONHASHSEED=random
export PYTHONDOCS=/usr/share/doc/python-3/html
EOF
}

