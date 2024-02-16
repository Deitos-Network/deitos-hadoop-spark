#!/bin/bash

export SPARK_PUBLIC_DNS=$(hostname -f)

sleep 30;
echo "Starting Hadoop history server..."
mapred --daemon start historyserver 
# mapred historyserver

echo "Starting Spark history server..."
spark-class org.apache.spark.deploy.history.HistoryServer 
while true; do sleep 1000; done
