#/bin/bash

build_compile()
{
    #Unpack embedded tarball
    tar -xf lsof_4.91_src.tar
    cd lsof_4.91_src           

    ./Configure -n linux 

    make CFGL="-L./lib -ltirpc"
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/bin
    install -v -m0755 -o root -g root lsof $BUILD_PACK/usr/bin

    bandit_mkdir $BUILD_PACK/usr/share/man/man8
    install -v lsof.8 $BUILD_PACK/usr/share/man/man8
}
