#!/bin/bash

# Inicio do SSH
/etc/init.d/ssh start

# Abaixo temos o trecho que rodará apenas no master.
if [[ $HOSTNAME = master ]]; then
    
    # Formatamos o namenode
    hdfs namenode -format
    
    # Iniciamos os serviços
    $HADOOP_HOME/sbin/start-dfs.sh
    $HADOOP_HOME/sbin/start-yarn.sh
fi

# Loop com sleep
while :; do sleep 2073600; done