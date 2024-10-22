#!/bin/bash

# Inicio do SSH
/etc/init.d/ssh start

# Abaixo temos o trecho que rodará apenas no master.
if [[ $HOSTNAME == "master" ]]; then
    
    printf "Formatting filesystem ... \n"
    hdfs namenode -format -nonInteractive

    printf "Executing start-dfs ... \n"
    $HADOOP_HOME/sbin/start-dfs.sh

    printf "Executing start-yarn ... \n"
    $HADOOP_HOME/sbin/start-yarn.sh
fi

# Starting bash terminal for keeping slaves alive
/bin/bash