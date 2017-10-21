#!/bin/bash

build_compile()
{
    pushd src
    
    gcc -O9 -s cups-pdf.c -o cups-pdf -lcups

    popd   
}

build_pack()
{
    bandit_mkdir $BUILD_PACK/usr/lib/cups/backend
    cp -v src/cups-pdf $BUILD_PACK/usr/lib/cups/backend
    # Force runtime root permissions for cups-pdf
    chmod 700 $BUILD_PACK/usr/lib/cups/backend/cups-pdf

    bandit_mkdir $BUILD_PACK/usr/share/cups/model/Generic
    cp -v extra/CUPS-PDF_opt.ppd   $BUILD_PACK/usr/share/cups/model/Generic
    cp -v extra/CUPS-PDF_noopt.ppd $BUILD_PACK/usr/share/cups/model/Generic

    bandit_mkdir $BUILD_PACK/etc
    cp -v extra/cups-pdf.conf $BUILD_PACK/etc/cups
    cat >> $BUILD_PACK/etc/cups/cups-pdf.conf <<"EOF"

### Default phyglos-printing configuration
Out         ${HOME}/PDF
AnonDirName ${HOME}/PDF
LogType     1
PDFVer      1.5
###
EOF
}

install_setup()
{
    /etc/init.d/cups restart
}
