# Tooling for Deitos Network - Hadoop / Yarn / Spark / Jupyter / Llama2

## Software

* [Hadoop 3.3.4](https://hadoop.apache.org/)

* [Hive 3.1.3](http://hive.apache.org/)

* [Spark 3.4.1](https://spark.apache.org/)

## Quick Start

To deploy the cluster, run:
```
make
docker-compose up
```

## Access interfaces with the following URL

### Hadoop

ResourceManager: http://localhost:8088

NameNode: https://localhost:50470

HistoryServer: http://localhost:19888

### Spark
master: http://localhost:8080


### Jupyter Notebook
URL: http://localhost:8888

example: [jupyter/notebook/pyspark.ipynb](jupyter/notebook/pyspark.ipynb)