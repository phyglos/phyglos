#!/bin/bash
 

build_compile()
{
    patch -Np1 -i $BUILD_SOURCES/mesa-11.1.2-add_xdemos-1.patch

    CFLAGS="-O2" CXXFLAGS="-O2"        \
    ./autogen.sh                       \
        --prefix=$PHY_XORG_PREFIX      \
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

    install -v -dm755 $BUILD_PACK/usr/share/doc/MesaLib-11.1.2
    cp -vrf docs/*    $BUILD_PACK/usr/share/doc/MesaLib-11.1.2

    make DESTDIR=$BUILD_PACK -C xdemos DEMOS_PREFIX=$XORG_PREFIX install
}
