FROM deitos-base-image

USER root

RUN apt-get -qq update  \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq install --no-install-recommends \
      sudo \
      openjdk-8-jdk \
      curl \
      gnupg \
      procps \
      python3.10 \
      python3.10-distutils \
      python-is-python3 \
      coreutils \
      libc6-dev \
      krb5-user \
      libkrb5-dev \
      libkrb5-3 
#  && rm -rf /var/lib/apt/lists/*

ARG USERNAME=jovyan
ARG GROUPNAME=jovyan
ARG UID=1001
ARG GID=1001

RUN mkdir /home/jovyan/keytabs
RUN chown jovyan:root /home/jovyan/keytabs

USER $USERNAME

ENV NAMEDIR=/opt/hadoop/dfs/name
RUN mkdir -p /opt/hadoop/dfs/name
VOLUME /opt/hadoop/dfs/name

#ENV NAMESECONDDIR=/opt/hadoop/dfs/namesecondary
#RUN mkdir -p /opt/hadoop/dfs/namesecondary
#VOLUME /opt/hadoop/dfs/namesecondary

COPY --chown=$USERNAME:$GROUPNAME ldap/ou.ldif /home/jovyan/ou.ldif
COPY --chown=$USERNAME:$GROUPNAME ldap/group.ldif /home/jovyan/group.ldif
COPY --chown=$USERNAME:$GROUPNAME ldap/person.ldif /home/jovyan/person.ldif

ENV SPARK_MASTER_ADDRESS=spark://master.deitos.network:7077
ENV SPARK_LOGS_HDFS_PATH=/var/log/spark
ENV SPARK_JARS_HDFS_PATH=/spark/jars

ENV KRB5CCNAME=/tmp/krb5cc

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh 
CMD ["run.sh"]