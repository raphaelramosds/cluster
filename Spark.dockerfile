# Use hadoop as the base image
FROM raphael/base-hadoop

# Spark runtime scripts
ENV PATH=$PATH:$HADOOP_HOME/spark/bin:$HADOOP_HOME/spark/sbin

# Spark enviroment
ENV SPARK_VERSION=3.5.3
ENV SPARK_MINOR_VERSION=3.5
ENV SPARK_HOME=$HADOOP_HOME/spark

# Download and install spark if needed
RUN mkdir -p ${SPARK_HOME}
RUN wget -nc -c --no-check-certificate "https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz"
RUN tar zvxf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C ${SPARK_HOME} --strip-components=1
RUN rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

# Udpate root permisions of spark directories
RUN chown -R root:root ${HADOOP_HOME}

# Copy spark files
COPY /config/spark/* ${SPARK_HOME}/conf/

# Execute bootstrap.sh once the container is started
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]