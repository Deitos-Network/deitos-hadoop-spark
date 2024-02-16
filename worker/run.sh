#!/bin/bash

export SPARK_PUBLIC_DNS=$(hostname -f)

echo "Starting Hadoop data node..."
hdfs --daemon start datanode
# hdfs datanode

echo "Starting Hadoop node manager..."
yarn --daemon start nodemanager
# yarn nodemanager

echo "Starting Spark slave node..."
spark-class org.apache.spark.deploy.worker.Worker "spark://master.deitos.network:7077" 

while true; do sleep 1000; done
