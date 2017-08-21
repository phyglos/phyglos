#!/bin/bash

script_run()
{
    # Strip debug symbols
    $BANDIT_BUILDER_DIR/bin/find /{,usr/}{bin,lib,sbin} -type f \
	-exec $BANDIT_BUILDER_DIR/bin/strip --strip-debug '{}' ';' 2>&1

    # Remove unnecessary libraries
    rm -vf /usr/lib/lib{bfd,opcodes}.a
    rm -vf /usr/lib/libbz2.a
    rm -vf /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
    rm -vf /usr/lib/libltdl.a
    rm -vf /usr/lib/libz.a

    # Remove temporary files
    rm -rf /tmp/*
}

