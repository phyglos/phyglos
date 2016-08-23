#!/bin/bash

script_run()
{
    # Strip debuggins symbols
    strip --strip-debug $BANDIT_BUILDER_DIR/lib/*
    /usr/bin/strip --strip-unneeded $BANDIT_BUILDER_DIR/{,s}bin/*

    # Remove unnecessary documentation
    rm -rf $BANDIT_BUILDER_DIR/{,share}/{info,man,doc}
}
