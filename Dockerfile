# Base image is a slim version of Open JDK
FROM openjdk:11-jdk-slim

# Hadoop and Spark enviroment for this image
ENV HADOOP_VERSION=3.4.0
ENV HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION
ENV SPARK_VERSION=3.5.3
ENV SPARK_HOME=$HADOOP_HOME/spark
ENV KAFKA_HOME=$SPARK_HOME/kafka

# Update packages
RUN apt-get update

# Install required packages
RUN apt-get install -y wget vim ssh openssh-server curl iputils-ping python3 python3-pip python3-dev build-essential libssl-dev sudo

# Copy and extract dependencies
COPY hadoop-${HADOOP_VERSION}.tar.gz ./
RUN tar zvxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/
RUN rm hadoop-${HADOOP_VERSION}.tar.gz 
RUN rm -rf ${HADOOP_HOME}/share/doc

RUN mkdir -p ${SPARK_HOME}
COPY spark-${SPARK_VERSION}-bin-hadoop3.tgz ./
RUN tar zvxf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C ${SPARK_HOME} --strip-components=1
RUN rm spark-${SPARK_VERSION}-bin-hadoop3.tgz

RUN mkdir -p ${KAFKA_HOME}
COPY kafka_2.12-3.4.1.tgz ./
RUN tar xzvf kafka_2.12-3.4.1.tgz -C ${KAFKA_HOME} --strip-components=1
RUN rm kafka_2.12-3.4.1.tgz

RUN mkdir -p ${KAFKA_HOME}/connect
COPY debezium-connector-postgres-2.3.0.Final-plugin.tar.gz ./
RUN tar zvxf debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -C ${KAFKA_HOME}/connect
RUN rm debezium-connector-postgres-2.3.0.Final-plugin.tar.gz

COPY debezium-connector-mongodb-2.7.3.Final-plugin.tar.gz ./
RUN tar zvxf debezium-connector-mongodb-2.7.3.Final-plugin.tar.gz -C ${KAFKA_HOME}/connect
RUN rm debezium-connector-mongodb-2.7.3.Final-plugin.tar.gz

# Copy Debezium MongoDB connect
COPY config/debezium/mongodb.json ${KAFKA_HOME}/connect/debezium-connector-mongodb

# Set up KRaft properties
RUN sed -i \
    -e 's/^controller\.quorum\.voters=.*/controller.quorum.voters=1@master:9093/' \
    -e 's/^listeners=.*/listeners=PLAINTEXT:\/\/master:9092,CONTROLLER:\/\/master:9093/' \
    -e 's/^advertised\.listeners=.*/advertised.listeners=PLAINTEXT:\/\/master:9092/' \
    ${KAFKA_HOME}/config/kraft/server.properties

# Set up Kafka Connect
RUN sed -i \
    -e "s/^bootstrap\.servers=.*/bootstrap.servers=master:9092/" \
    -e "s|^#plugin\.path=.*|plugin.path=${KAFKA_HOME}/connect|" \
    ${KAFKA_HOME}/config/connect-standalone.properties

# Give root permisions of hadoop directories
RUN chown -R root:root ${HADOOP_HOME}

# Exporting JAVA_HOME to environment
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment

# Generate SSH key for nodes being able to remotely access each other
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys
COPY config/config /root/.ssh
RUN chmod 600 /root/.ssh/config

# Run commands as sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy hadoop and spark config files
COPY config/hadoop/* /usr/hadoop-${HADOOP_VERSION}/etc/hadoop/
COPY config/spark/* ${SPARK_HOME}/conf/

# Copy JDBC driver to jars folder
COPY postgresql-42.7.4.jar ${SPARK_HOME}/jars/

# Load environment variables into .bashrc file
COPY config/enviroment /
RUN cat enviroment >> /root/.bashrc

# Move bootstrap.sh into containera and give executions permissions
COPY config/bootstrap.sh /
RUN chmod 0700 bootstrap.sh

# Execute bootstrap.sh once the container is started
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]