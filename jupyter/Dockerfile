ARG PYTHON_VERSION=3.10
FROM deitos-hadoop-base AS base
FROM jupyter/minimal-notebook:python-3.10.4

USER root

RUN apt-get -qq update  \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
      sudo \
      openjdk-8-jdk \
      curl \
      python3 \
      python3-distutils \
      python-is-python3 \
      python3-venv \
      coreutils \
      libc6-dev \
      krb5-user \
      libkrb5-dev \
      libkrb5-3       
#  && sudo rm -rf /var/lib/apt/lists/*

ARG USERNAME=jovyan

USER $USERNAME

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Hadoop
COPY --from=base  /opt/hadoop /opt/hadoop
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
ENV PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
ENV LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

# Spark
COPY --from=base  /opt/spark /opt/spark
ENV SPARK_HOME=/opt/spark
ENV PYTHONHASHSEED=1
ENV PYSPARK_PYTHON=python3
ENV SPARK_CONF_DIR=$SPARK_HOME/conf
ENV PATH=$SPARK_HOME/sbin:$SPARK_HOME/bin:$PATH

# Hive
COPY --from=base  /opt/hive /opt/hive
ENV HIVE_HOME=/opt/hive
ENV HIVE_CONF_DIR=$HIVE_HOME/conf

# ENV KRB5CCNAME=/tmp/krb5cc

ENV PATH=$HIVE_HOME/sbin:$HIVE_HOME/bin:$PATH

RUN pip install -U pip 
RUN pip install --no-cache-dir \
    pandas \
    openpyxl \
    findspark 

COPY notebook /home/jovyan/work