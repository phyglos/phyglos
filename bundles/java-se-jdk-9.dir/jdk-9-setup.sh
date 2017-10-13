#!/bin/bash

script_run()
{
    cat > /etc/profile.d/jdk-9.sh <<EOF
export JAVA_HOME=${PHY_JAVA_HOME}
export PATH=\$PATH:\$JAVA_HOME/bin
EOF
}

script_reverse()
{
    rm -f /etc/profile.d/jdk-9.sh
}
