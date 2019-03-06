#!/bin/bash 

build_compile()
{
    sed -i '/skipping/d' util/packer.c

    ./configure   \
        --prefix=/usr    \
        --disable-static \
        --with-default-dict=/lib/cracklib/pw_dict
    
    make
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/lib
    mv -v $BUILD_PACK/usr/lib/libcrack.so.* $BUILD_PACK/lib
    ln -sfv ../../lib/$(readlink $BUILD_PACK/usr/lib/libcrack.so) $BUILD_PACK/usr/lib/libcrack.so

    bandit_mkdir $BUILD_PACK/usr/share/dict


    # Create default list of forbidden words
    install -v -m644 -D $BUILD_SOURCES/cracklib-words-2.9.7.gz \
                        $BUILD_PACK/usr/share/dict/cracklib-words.gz    
    ln -svf cracklib-words $BUILD_PACK/usr/share/dict/words

    # Create a list of extra forbidden words
    cat > $BUILD_PACK/usr/share/dict/cracklib-extra-words << EOF
bandit
phy
phyglos
EOF

    install -v -m755 -d $BUILD_PACK/lib/cracklib

}

install_setup()
{
    bandit_pushd /usr/share/dict/

    rm -rf cracklib-words
    gunzip cracklib-words.gz

    # Add intallation time extra forbidden words
    cat >> $BUILD_PACK/usr/share/dict/cracklib-extra-words << EOF
$(hostname)
EOF

    # Create first set of forbidden words
    create-cracklib-dict cracklib-words cracklib-extra-words   

    bandit_popd
}
