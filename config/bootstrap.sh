#!/bin/bash

# For convenience's sake
BLUE=$(tput setaf 4)
GREEN_COLOR=$(tput setaf 2)
YELLOW_COLOR=$(tput setaf 3)
RESET_COLORS=$(tput sgr0)
INFO="[${BLUE}INFO${RESET_COLORS}]"
SUCCESS="[${GREEN_COLOR}SUCCESS${RESET_COLORS}]"
WARNING="[${YELLOW_COLOR}WARNING${RESET_COLORS}]"

# Start SSH service
/etc/init.d/ssh start

# Load .bashrc
source ~/.bashrc

# Only execute this on master
if [[ $HOSTNAME == "master" ]]; then

    printf "${INFO} Formatting filesystem \n"
    hdfs namenode -format -nonInteractive
    printf "${SUCCESS} Filesystem formated\n"

    printf "${INFO} Starting DFS\n"
    $HADOOP_HOME/sbin/start-dfs.sh
    printf "${SUCCESS} DFS started\n"

    printf "${INFO} Starting Yarn\n"
    $HADOOP_HOME/sbin/start-yarn.sh
    printf "${SUCCESS} Yarn started\n"

    printf "${INFO} Creating Spark logs\n"
    hdfs dfs -mkdir /spark-logs
    printf "${SUCCESS} Spark logs created\n"

    printf "${INFO} Sending JAR files to HDFS\n"
    hdfs dfs -mkdir /spark-libs
    hdfs dfs -put $HADOOP_HOME/spark/jars/*.jar /spark-libs/
    printf "${SUCCESS} JAR files sent\n"

    printf "${INFO} Starting Spark history server\n"
    $SPARK_HOME/sbin/start-history-server.sh
    printf "${SUCCESS} History server launched\n"

    printf "${INFO} Creating Kafka logs\n"
    kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c $KAFKA_HOME/config/kraft/server.properties
    printf "${SUCCESS} Kafka logs created\n"

    printf "${INFO} Starting Kafka server\n"
    kafka-server-start.sh $KAFKA_HOME/config/kraft/server.properties
    printf "${SUCCESS} Kafka server started\n"

    printf "${INFO} Starting Kafka Connect\n"
    connect-standalone.sh $KAFKA_HOME/config/connect-standalone.properties
    printf "${SUCCESS} Kafka Connect started\n"

    printf "${SUCCESS} CODE AWAY!\n"
fi

# Starting bash terminal for keeping slaves alive
/bin/bash

