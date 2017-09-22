#!/bin/bash

build_pack()
{
    bandit_mkdir $BUILD_PACK/$PHY_DROPBOX_HOME/
    cp -R .dropbox-dist/* $BUILD_PACK/$PHY_DROPBOX_HOME/
}

