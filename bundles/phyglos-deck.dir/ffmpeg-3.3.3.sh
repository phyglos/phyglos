#!/bin/bash

build_compile()
{
    sed -i 's/-lflite"/-lflite -lasound"/' configure

    ./configure              \
	--prefix=/usr        \
        --enable-gpl         \
        --enable-version3    \
        --enable-nonfree     \
        --disable-static     \
        --enable-shared      \
        --disable-debug      \
        --enable-libfdk-aac  \
        --enable-libfreetype \
        --enable-libtheora   \
        --enable-libvorbis   \
        --enable-libvpx      \
        --enable-libx264     \
        --enable-libx265     \
        --docdir=/usr/share/doc/ffmpeg-3.3.3

##        --enable-libass      \
##        --enable-libmp3lame  \
##        --enable-libopus     \

    make 

    gcc tools/qt-faststart.c -o tools/qt-faststart
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    bandit_mkdir $BUILD_PACK/usr/bin
    cp -v  tools/qt-faststart $BUILD_PACK/usr/bin
    
    bandit_mkdir $BUILD_PACK/usr/share/doc
    cp -v doc/*.txt $BUILD_PACK/usr/share/doc/ffmpeg-3.3.3
}
