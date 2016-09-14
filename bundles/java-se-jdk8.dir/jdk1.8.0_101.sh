#!/bin/bash

build_pack()
{
    bandit_mkdir $BUILD_PACK/$PHY_JAVA_HOME/
    cp -R * $BUILD_PACK/$PHY_JAVA_HOME/
}

