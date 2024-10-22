#!/bin/bash

# Start SSH service
/etc/init.d/ssh start

# Only execute this on master
if [[ $HOSTNAME == "master" ]]; then
    
    # FIXME (please) Avoid formatting HDFS every time the container start
    printf "Formatting filesystem ... \n"
    hdfs namenode -format -nonInteractive

    printf "Executing start-dfs ... \n"
    $HADOOP_HOME/sbin/start-dfs.sh

    printf "Executing start-yarn ... \n"
    $HADOOP_HOME/sbin/start-yarn.sh
fi

# Starting bash terminal for keeping slaves alive
/bin/bash