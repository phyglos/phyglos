#!/bin/bash

build_pack()
{
    make DESTDIR=$BUILD_PACK install
}
