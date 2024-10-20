#!/bin/bash

# Este trecho rodará independente de termos um container master ou worker. 
# Necesário para funcionamento do HDFS e para comunicação dos containers/nodes.
/etc/init.d/ssh start

# Abaixo temos o trecho que rodará apenas no master.
if [[ $HOSTNAME = master ]]; then
    
    # Formatamos o namenode
    hdfs namenode -format
    
    # Iniciamos os serviços
    $HADOOP_HOME/sbin/start-dfs.sh
    $HADOOP_HOME/sbin/start-yarn.sh

    # Inicio do mysql - metastore o Hive
    service mysql start

    # Criação de diretórios no ambiente distribuído do HDFS
    hdfs dfs -mkdir /datasets
    hdfs dfs -mkdir /datasets_processed


# E abaixo temos o trecho que rodará nos workers
else
    # Configs de HDFS nos dataNodes (workers)
    $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode &
    $HADOOP_HOME/bin/yarn nodemanager &
fi

# Induzindo um loop com sleep (para facilitar diagnóstico caso os containers passem pelos comando acima sem executar)
while :; do sleep 2073600; done