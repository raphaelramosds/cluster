FROM openjdk:8-jdk-slim

# Variaveis de ambiente do Hadoop
ENV HADOOP_VERSION 2.7.3
ENV HADOOP_MINOR_VERSION 2.7
ENV HADOOP_HOME /usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

# Ajustes e instalação dos componentes do cluster
RUN apt-get update \
    && apt-get install -y wget vim ssh openssh-server curl iputils-ping \
    python3 python3-pip python3-dev \
    build-essential libssl-dev libffi-dev libpq-dev mariadb-server libmariadb-java \
    && python3 -m pip install dask[bag] --upgrade \
    && python3 -m pip install --upgrade toree \
    && python3 -m bash_kernel.install \
    && python3 -c "import nltk; nltk.download('stopwords')"\
    && mkdir datasets \
    # Hadoop
    && wget \
    "http://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz" \
    && tar zvxf hadoop-${HADOOP_VERSION}.tar.gz -C /usr/ \
    && rm hadoop-${HADOOP_VERSION}.tar.gz \
    && rm -rf ${HADOOP_HOME}/share/doc \
    && chown -R root:root ${HADOOP_HOME} \
    # Configurando o JAVA_HOME para os processos localizarem a instalação do Java
    && echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/environment

# Keys dos nodes. Necessarias para se comunicarem por SSH
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys
COPY /config/config /root/.ssh
RUN chmod 600 /root/.ssh/config

# Todos os arquivos de configuracao que devem ser copiados para dentro do container estao aqui
COPY config/hadoop/*.xml /usr/hadoop-${HADOOP_VERSION}/etc/hadoop/
COPY config/scripts /

EXPOSE 9000 4040 8020 22 9083

ENTRYPOINT ["/bin/bash", "bootstrap.sh"]