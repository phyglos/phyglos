#!/bin/bash

build_pack()
{
    bandit_mkdir $BANDIT_HOME/lib/blfs-bootscripts
    cp -vR * $BANDIT_HOME/lib/blfs-bootscripts
}

