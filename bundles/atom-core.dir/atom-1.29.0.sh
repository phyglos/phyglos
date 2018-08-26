#!/bin/bash
    
build_compile()
{
    script/build
}

build_pack()
{  
    bandit_mkdir $BUILD_PACK/usr/lib/atom
    cp -vR out/atom-1.29.0-amd64/* $BUILD_PACK/usr/lib/atom

    bandit_mkdir $BUILD_PACK/usr/bin
    ln -sf /usr/lib/atom/atom $BUILD_PACK/usr/bin/atom

    for png in resources/app-icons/stable/png/*; do
	local name=$(basename ${png})
	local size=${name/.png/}
	local dir="$BUILD_PACK/usr/share/icons/hicolor/${size}x${size}/apps"
	bandit_mkdir $dir
	cp -v $png $dir/atom.png
    done

    bandit_mkdir $BUILD_PACK/usr/share/applications
    cat > $BUILD_PACK/usr/share/applications/atom.desktop << "EOF"
[Desktop Entry]
Encoding=UTF-8
Name=Atom Editor
Comment="A hackable text editor for the 21st Century"
GenericName=Atom editor
Type=Application
Icon=atom
Categories=Development
MimeType=text/plain
Exec=atom %u
Terminal=false
StartupNotify=false
EOF

}

install_setup()
{
    gtk-update-icon-cache -t -f /usr/share/icons/hicolor
    
    update-mime-database -n /usr/local/share/mime
    
    update-desktop-database -q
}

