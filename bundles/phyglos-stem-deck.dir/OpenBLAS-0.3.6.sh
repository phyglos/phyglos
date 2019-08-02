#/bin/bash 

build_compile()
{
    INTERFACE=64 \
    make libs netlib shared
}

build_pack()
{
    make PREFIX=/usr \
         DESTDIR=$BUILD_PACK \
         install
}
