#!/bin/bash

build_compile()
{
    ./configure                         \
	--prefix=/usr                   \
	--with-gitconfig=/etc/gitconfig \
	--with-libpcre                  

    make
}

build_test_level=4
build_test()
{
    make test
}

build_pack()
{
    make DESTDIR=$BUILD_PACK install

    ## Install man pages package
    bandit_mkdir $BUILD_PACK/usr/share/man
    tar -xf $BUILD_SOURCES/git-manpages-2.19.1.tar.xz \
	-C  $BUILD_PACK/usr/share/man \
	--no-same-owner --no-overwrite-dir
    
    # Make git-gui available
    ln -s ../libexec/git-core/git-gui $BUILD_PACK/usr/bin

    bandit_mkdir $BUILD_PACK/usr/share/applications
    cat > $BUILD_PACK/usr/share/applications/git-gui.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Git GUI
Comment=Git graphucal interface
GenericName=Git GUI
Type=Application
Icon=/usr/share/git-gui/lib/git-gui.ico
Categories=Development
MimeType=text/plain
Exec=git-gui
Terminal=false
StartupNotify=false
EOF
    
}

install_setup()
{
    # Set global editor
    [[ -z "$GIT_EDITOR" ]] || git config --system core.editor "$GIT_EDITOR"

    # Define global alias
    git config --system alias.st status
    git config --system alias.co commit
    git config --system alias.ck checkout 
    git config --system alias.lp log --pretty=oneline

    # Update desktop 
    gtk-update-icon-cache -t -f /usr/share/icons/hicolor
    update-mime-database -n /usr/local/share/mime
    update-desktop-database -q
}
