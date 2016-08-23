#!/bin/bash

./configure $XORG_CONFIG \
            --with-udev-rules-dir=/lib/udev/rules.d \
            --without-hal-callouts-dir \
            --without-hal-fdi-dir &&
make

make install
