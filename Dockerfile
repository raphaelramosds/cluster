# Base image
FROM ubuntu:22.04

# Hadoop and Spark enviroment for this image
ENV HADOOP_VERSION=3.4.0
ENV HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION
ENV SPARK_VERSION=3.5.3
ENV SPARK_HOME=$HADOOP_HOME/spark
ENV KAFKA_HOME=$SPARK_HOME/kafka

# Copy dependencies
COPY *gz ./
COPY postgresql-42.7.4.jar ${SPARK_HOME}/jars/

# Create base directories
RUN mkdir -p ${SPARK_HOME} ${KAFKA_HOME} ${KAFKA_HOME}/connect

# Extract dependencies
RUN tar zxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/
RUN tar zxf spark-${SPARK_VERSION}-bin-hadoop3.tgz -C ${SPARK_HOME} --strip-components=1
RUN tar xzf kafka_2.12-3.4.1.tgz -C ${KAFKA_HOME} --strip-components=1
RUN tar zxf debezium-connector-postgres-2.3.0.Final-plugin.tar.gz -C ${KAFKA_HOME}/connect
RUN tar zxf debezium-connector-mongodb-2.7.3.Final-plugin.tar.gz -C ${KAFKA_HOME}/connect

# Copy config files
COPY config/hadoop/* /usr/hadoop-${HADOOP_VERSION}/etc/hadoop/
COPY config/spark/* ${SPARK_HOME}/conf/
COPY config/bootstrap.sh /
COPY config/env /

# Update and Install required packages
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends wget vim ssh openssh-server curl iputils-ping python3 python3-pip python3-dev build-essential libssl-dev sudo openjdk-11-jdk-headless

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

# Generate SSH key for nodes being able to remotely access each other
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys
COPY config/config /root/.ssh
RUN chmod 600 /root/.ssh/config

# Run commands as sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Append env variables on .bashrc
RUN cat env >> /root/.bashrc

# Cleaning
RUN sudo rm -rf /tmp/* /var/tmp/* ${HADOOP_HOME}/share/doc
RUN sudo rm *gz

# Give executions permissions
RUN chmod 0700 bootstrap.sh

# Execute bootstrap.sh once the container is started
ENTRYPOINT [ "./bootstrap.sh" ]