#!/bin/bash

build_compile()
{
    CXX="/usr/bin/g++"      \
    ./configure             \
	--prefix=/usr       \
	--enable-shared     \
	--enable-optimizations \
	--with-system-expat \
	--with-ensurepip=yes
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.7m.so
    chmod -v 755 $BUILD_PACK/usr/lib/libpython3.so

    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/python3.sh <<EOF
export PYTHONHASHSEED=random
export PYTHONDOCS=/usr/share/doc/python-3/html
EOF
}

