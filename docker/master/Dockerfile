FROM raphael/base-hadoop:2.4.6

COPY config/hadoop/masters $HADOOP_HOME/conf/
COPY config/hadoop/slaves $HADOOP_HOME/conf/

EXPOSE 8080 7077 6066 7001 8030 8031 8032 2181 2888 3888

ENTRYPOINT ["/bin/bash", "bootstrap.sh"]