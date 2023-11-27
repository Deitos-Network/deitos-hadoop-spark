FROM deitos-hadoop-base

ENV DATADIR=/opt/hadoop/dfs/data
RUN mkdir -p /opt/hadoop/dfs/data
VOLUME /opt/hadoop/dfs/data

ENV SPARK_PUBLIC_DNS=localhost
ENV SPARK_MASTER_ADDRESS=spark://master.deitos.network:7077

# COPY ../keytabs/* $HADOOP_CONF_DIR/keytabs

# ENV HDFS_NAMENODE_USER=root
# ENV HDFS_DATANODE_USER=root
# ENV HDFS_SECONDARYNAMENODE_USER=root
# ENV YARN_RESOURCEMANAGER_USER=root
# ENV YARN_NODEMANAGER_USER=root
# ENV JSVC_HOME=/usr/bin
# ENV HDFS_DATANODE_SECURE_USER=root

ENV KRB5CCNAME=/tmp/krb5cc

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
# CMD ["run.sh"]
ENTRYPOINT [ "run.sh"]