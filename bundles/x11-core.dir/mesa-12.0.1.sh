#!/bin/bash

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/mesa-12.0.1-add_xdemos-1.patch

    sed -i "/pthread-stubs/d" configure.ac
    sed -i "/seems to be moved/s/^/: #/" bin/ltmain.sh
    
    CFLAGS="-O2" CXXFLAGS="-O2"        \
    ./autogen.sh                       \
        --prefix=$XORG_PREFIX          \
        --sysconfdir=/etc              \
        --enable-texture-float         \
        --enable-gles1                 \
        --enable-gles2                 \
        --enable-osmesa                \
        --enable-xa                    \
        --enable-gbm                   \
        --enable-glx-tls               \
        --with-egl-platforms=$PHY_XORG_EGL_PLATFORMS     \
        --with-gallium-drivers=$PHY_XORG_GALLIUM_DRIVERS 

    make

    make -C xdemos DEMOS_PREFIX=$XORG_PREFIX
}

build_test_level=4
build_test()
{
    make check 
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/share/doc/mesa-12.0.1
    cp -rf docs/* $BUILD_PACK/usr/share/doc/mesa-12.0.1

    make DESTDIR=$BUILD_PACK \
	 DEMOS_PREFIX=$XORG_PREFIX \
	 -C xdemos install
}
