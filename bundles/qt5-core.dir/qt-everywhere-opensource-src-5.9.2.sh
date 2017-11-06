#!/bin/bash

build_compile()
{

    ./configure                                     \
	-prefix $PHY_QT5_HOME                       \
        -sysconfdir /etc/xdg                        \
        -confirm-license                            \
        -opensource                                 \
        -dbus-linked                                \
        -no-openssl                                 \
        -system-harfbuzz                            \
        -system-sqlite                              \
        -nomake examples                            \
        -nomake tests                               \
        -no-rpath                                   \
        -skip qtwebengine
   
    make
}

build_pack()
{
    make INSTALL_ROOT=$BUILD_PACK install

    # Remove references to build directory
    find $BUILD_PACK$PHY_QT5_HOME/ -name \*.prl -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \;
    
    QT5BINDIR=$PHY_QT5_HOME/bin
    # Add extra expected symlinks for some other applications
    for file in moc uic rcc qmake lconvert lrelease lupdate; do
	ln -sfrvn $QT5BINDIR/$file /usr/bin/$file-qt5
    done

    bandit_mkdir $BUILD_PACK/usr/share/pixmaps
    cp -v qttools/src/assistant/assistant/images/assistant-128.png \
          $BUILD_PACK/usr/share/pixmaps/assistant-qt5.png
    cp -v qttools/src/designer/src/designer/images/designer.png \
          $BUILD_PACK/usr/share/pixmaps/designer-qt5.png
    cp -v qttools/src/linguist/linguist/images/icons/linguist-128-32.png \
          $BUILD_PACK/usr/share/pixmaps/linguist-qt5.png
    cp -v qttools/src/qdbus/qdbusviewer/images/qdbusviewer-128.png \
          $BUILD_PACK/usr/share/pixmaps/qdbusviewer-qt5.png

    bandit_mkdir $BUILD_PACK/usr/share/applications
    cat > $BUILD_PACK/usr/share/applications/assistant-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Assistant
Comment=Shows Qt5 documentation and examples
Exec=$QT5BINDIR/assistant
Icon=assistant-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Documentation;
EOF

    cat > $BUILD_PACK/usr/share/applications/designer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Designer
GenericName=Interface Designer
Comment=Design GUIs for Qt5 applications
Exec=$QT5BINDIR/designer
Icon=designer-qt5.png
MimeType=application/x-designer;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF
    
    cat > $BUILD_PACK/usr/share/applications/linguist-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 Linguist
Comment=Add translations to Qt5 applications
Exec=$QT5BINDIR/linguist
Icon=linguist-qt5.png
MimeType=text/vnd.trolltech.linguist;application/x-linguist;
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;
EOF

    cat > $BUILD_PACK/usr/share/applications/qdbusviewer-qt5.desktop << EOF
[Desktop Entry]
Name=Qt5 QDbusViewer
GenericName=D-Bus Debugger
Comment=Debug D-Bus applications
Exec=$QT5BINDIR/qdbusviewer
Icon=qdbusviewer-qt5.png
Terminal=false
Encoding=UTF-8
Type=Application
Categories=Qt;Development;Debugger;
EOF

    bandit_mkdir $BUILD_PACK/etc/profile.d
    cat > $BUILD_PACK/etc/profile.d/qt5.sh << "EOF"
QT5DIR=/opt/qt5

pathappend $QT5DIR/bin           PATH
pathappend $QT5DIR/lib/pkgconfig PKG_CONFIG_PATH

export QT5DIR
EOF

}

install_setup()
{
    cat >> /etc/ld.so.conf.d/qt5.conf << EOF
$PHY_QT5_HOME/lib
EOF
    ldconfig
}

remove_setup()
{
    rm /etc/ld.so.conf.d/qt5.conf
    ldconfig
}
