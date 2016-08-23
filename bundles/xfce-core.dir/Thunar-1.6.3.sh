#!/bin/bash

./configure --prefix=/usr \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/Thunar-1.6.3 &&
make

sudo make install
