FROM deitos-hadoop-base

ENV DATADIR=/opt/hadoop/dfs/data
RUN mkdir -p /opt/hadoop/dfs/data
VOLUME /opt/hadoop/dfs/data

ENV SPARK_MASTER_ADDRESS=spark://master.deitos.network:7077

ENV KRB5CCNAME=/tmp/krb5cc

COPY run.sh /usr/local/sbin/run.sh
RUN sudo chmod a+x /usr/local/sbin/run.sh
ENTRYPOINT [ "run.sh"]