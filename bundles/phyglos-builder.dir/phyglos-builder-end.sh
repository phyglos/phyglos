#!/bin/bash

script_run()
{
    # Strip debuggins symbols
    strip --strip-debug $BANDIT_BUILDER_DIR/lib/* 2>&1
    /usr/bin/strip --strip-unneeded $BANDIT_BUILDER_DIR/{,s}bin/* 2>&1

    # Remove unnecessary documentation
    rm -rf $BANDIT_BUILDER_DIR/{,share}/{info,man,doc}
}
