#!/bin/bash

# For convenience's sake
BLUE=$(tput setaf 4)
GREEN_COLOR=$(tput setaf 2)
RESET_COLORS=$(tput sgr0)
INFO="[${BLUE}INFO${RESET_COLORS}]"
SUCCESS="[${GREEN_COLOR}SUCCESS${RESET_COLORS}]"

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

    printf "${INFO} Creating spark logs\n"
    hdfs dfs -mkdir /spark-logs
    printf "${SUCCESS} Spark logs created\n"

    printf "${INFO} Sending JAR files to HDFS\n"
    hdfs dfs -mkdir /spark-libs
    hdfs dfs -put $HADOOP_HOME/spark/jars/*.jar /spark-libs/
    printf "${SUCCESS} JAR files sent\n"

    printf "${INFO} Start spark history server\n"
    $SPARK_HOME/sbin/start-history-server.sh
    printf "${SUCCESS} History server launched\n"

    printf "${SUCCESS} CODE AWAY!\n"
fi

# Starting bash terminal for keeping slaves alive
/bin/bash

