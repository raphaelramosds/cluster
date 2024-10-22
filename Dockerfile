FROM openjdk:8-jdk-slim

ENV HADOOP_VERSION=3.4.0
ENV HADOOP_MINOR_VERSION=3.4
ENV HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="$HDFS_NAMENODE_USER"
ENV HDFS_SECONDARYNAMENODE_USER="$HDFS_NAMENODE_USER"
ENV YARN_RESOURCEMANAGER_USER="$HDFS_NAMENODE_USER"
ENV YARN_NODEMANAGER_USER="$HDFS_NAMENODE_USER"

ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin

RUN apt-get update

RUN apt-get install -y wget vim ssh openssh-server curl iputils-ping python3 python3-pip python3-dev build-essential libssl-dev sudo

RUN wget -nc -c --no-check-certificate "https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"

RUN tar zvxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/
RUN rm hadoop-${HADOOP_VERSION}.tar.gz 
RUN rm -rf ${HADOOP_HOME}/share/doc
RUN chown -R root:root ${HADOOP_HOME}

RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys
COPY /config/config /root/.ssh
RUN chmod 600 /root/.ssh/config

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

COPY config/hadoop/* /usr/hadoop-${HADOOP_VERSION}/etc/hadoop/
COPY config/scripts /

EXPOSE 9000 4040 8020 22 9083

ENTRYPOINT ["/bin/bash", "bootstrap.sh"]