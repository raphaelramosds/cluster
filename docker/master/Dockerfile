FROM raphael/base-hadoop

COPY config/hadoop/workers $HADOOP_CONF_DIR

EXPOSE 8080 7077 6066 7001 8030 8031 8032 2181 2888 3888

ENTRYPOINT ["/bin/bash", "bootstrap.sh"]