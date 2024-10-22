# Base image is a slim version of Open JDK
FROM openjdk:8-jdk-slim

# Hadoop env variables
ENV HADOOP_VERSION=3.4.0
ENV HADOOP_MINOR_VERSION=3.4
ENV HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV HDFS_NAMENODE_USER="root"
ENV HDFS_DATANODE_USER="$HDFS_NAMENODE_USER"
ENV HDFS_SECONDARYNAMENODE_USER="$HDFS_NAMENODE_USER"
ENV YARN_RESOURCEMANAGER_USER="$HDFS_NAMENODE_USER"
ENV YARN_NODEMANAGER_USER="$HDFS_NAMENODE_USER"
ENV PATH=$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin

# Update packages
RUN apt-get update

# Install required packages
RUN apt-get install -y wget vim ssh openssh-server curl iputils-ping python3 python3-pip python3-dev build-essential libssl-dev sudo

# Download and install hadoop if needed
RUN wget -nc -c --no-check-certificate "https://dlcdn.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"
RUN tar zvxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/
RUN rm hadoop-${HADOOP_VERSION}.tar.gz 
RUN rm -rf ${HADOOP_HOME}/share/doc

# Giving root permisions to hadoop directories
RUN chown -R root:root ${HADOOP_HOME}

# Exporting JAVA_HOME to environment
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment

# Generate SSH key for nodes being able to remotely access each other
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
RUN chmod 600 ~/.ssh/authorized_keys
COPY /config/config /root/.ssh
RUN chmod 600 /root/.ssh/config

# Run commands as sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Copy hadoop config files to 
COPY config/hadoop/* /usr/hadoop-${HADOOP_VERSION}/etc/hadoop/

# Move bootstrap.sh into container
COPY config/scripts /

# Give execution permissions to bootstrap.sh
RUN chmod 0700 bootstrap.sh

# Execute bootstrap.sh once the container is started
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]