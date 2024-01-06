# Tooling for Deitos Network - Hadoop / Yarn / Spark / Jupyter / Llama2

## Software

* [Hadoop 3.3.6](https://hadoop.apache.org/)
* [Hive 3.1.3](http://hive.apache.org/)
* [Spark 3.4.1](https://spark.apache.org/)
* [Jupyter 3.4.3](https://jupyter.org/)
* [Llama-2 7B](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF)


## Quick Start

To start the services, run:
```
make
./start.sh
```

## Checking Installation 

### Hadoop Services (HDFS / YARN / History)

ResourceManager: http://localhost:8088

NameNode: https://localhost:50470

HistoryServer: http://localhost:19888

### Spark Services (Master / Slaves)
master: http://localhost:8080


### Jupyter Notebook (UI for Interact with Hadoop Ecosystem)
URL: http://localhost:8888

example: [jupyter/notebook/pyspark.ipynb](http://jupyter.deitos.network:8888/notebooks/pyspark.ipynb)

## Testing Services Hadoop/Spark/Hive from Command-Line

Setting the hosts file with entries pointing to cluster services.( /etc/hosts file)

```
127.0.0.1       master.deitos.network
127.0.0.1       worker1.deitos.network
127.0.0.1       worker2.deitos.network
127.0.0.1       jupyter.deitos.network
```

To Test services is necessary install the following pre-requisites. (Show installation steps for Ubuntu distribution) :
1. Java 8
```
sudo apt-get install openjdk-8-jdk
```

2. Kerberos Client and Libraries
```
sudo apt-get install krb5-user libkrb5-dev libkrb5-3
```

Setting Kerberos clients to connect with Docker services, edit file named /etc/krb5.conf
```
[libdefaults]
        default_realm = DEITOS.NETWORK
        kdc_timesync = 1
        ccache_type = 4
        forwardable = true
        proxiable = true
        fcc-mit-ticketflags = true

[realms]
        DEITOS.NETWORK = {
                kdc = 172.28.1.7
                admin_server = 172.28.1.7
        }
```


3. curl
```
sudo apt-get install curl
```

4. Hadoop Software
These are the steps to make the installation: 
```
export HADOOP_VERSION=3.3.4

export HADOOP_URL=https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz

export HADOOP_HOME=/opt/hadoop

sudo mkdir $HADOOP_HOME

sudo chown <user>:root -R $HADOOP_HOME  

curl -fsSL $HADOOP_URL -o /tmp/hadoop.tar.gz

tar -xf /tmp/hadoop.tar.gz -C $HADOOP_HOME --strip-components 1

mkdir $HADOOP_HOME/logs

export  HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

export  PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH

export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

```
You should replace "user"  for the selected user in your linux to run hadoop

You could modify file .bashrc in your $HOME to adding the following lines:
```
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

export HADOOP_HOME=/opt/hadoop
export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

export PATH=$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH
export LD_LIBRARY_PATH=$HADOOP_HOME/lib/native:$LD_LIBRARY_PATH

export DYLD_LIBRARY_PATH=$JAVA_HOME/jre/lib/server
export LD_LIBRARY_PATH=$JAVA_HOME/jre/lib/amd64/server

```

Alter core-site.xml from your local Hadoop installation in $HADOOP_CONF_DIR/core-site.xml to set correct configuration
```
<?xml version="1.0" encoding="UTF-8"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
    <property>
        <name>fs.defaultFS</name>
        <value>hdfs://master.deitos.network</value>
    </property>
    <property>
      <name>hadoop.security.authentication</name>
      <value>kerberos</value>
    </property>
    <property>
      <name>hadoop.security.authorization</name>
      <value>true</value>
    </property>
</configuration>
```

Create user for the Interaction and Generate Keytab File
```
kadmin -p admin/admin -w admin -q "addprinc -randkey ramon/$(hostname -f)@DEITOS.NETWORK"

kadmin -p admin/admin -w admin -q "addprinc -randkey HTTP/$(hostname -f)@DEITOS.NETWORK"

kadmin -p admin/admin -w admin -q "xst -k current-localhost.keytab ramon/$(hostname -f)@DEITOS.NETWORK HTTP/$(hostname -f)@DEITOS.NETWORK HTTP/localhost"

kinit -kt current-localhost.keytab ramon/$(hostname -f)@DEITOS.NETWORK

```

To test the access to the services:
```
# Autheticate User
kinit -kt current-localhost.keytab ramon/$(hostname -f)@DEITOS.NETWORK

# Make ls to HDFS Filesystem
hdfs dfs -ls /data/ramon
```

To Upload File to the HDFS cluster using command-line, run:
```
hdfs dfs -put test/test.txt /data/ramon
```

## Testing Services Hadoop using WebHDFS

Enter in the Jupyter Node
```
docker exec -it deitos-hadoop-spark_jupyter_1 bash
```

To Upload File to the HDFS cluster using webHDFS API, execute:
```
# Autheticate User
kinit -kt /home/jovyan/keytabs/current-jupyter.keytab ramon/$(hostname -f)@DEITOS.NETWORK

# Get Delegation Token
curl -v -i -k --negotiate -u : "https://master.deitos.network:50470/webhdfs/v1/data/ramon?op=GETDELEGATIONTOKEN"

# List Directory
curl -v -i -k "https://master.deitos.network:50470/webhdfs/v1/?delegation=<token>LISTSTATUS"

# Define Upload Operation to API - The Response is a Redirect Address to Execute the final Operation
curl -v -i -k --negotiate -u : -X PUT "https://master.deitos.network:50470/webhdfs/v1/data/ramon/test.txt?delegation=<token>&op=CREATE"

# Upload File to the API
curl -i -k -X PUT -T test/test.txt "https://worker1.deitos.network:50075/webhdfs/v1/data/ramon/test.txt?op=CREATE&delegation=<token>&namenoderpcaddress=master.deitos.network:8020&createflag=&createparent=true&overwrite=true"
```

## Testing Services Hadoop/Spark/Hive from Jupyter Notebook

Access the Service using the Internet Browser and Open the Notebook named pyspark.ipnb

http://jupyter.deitos.network:8888/

Execute the instructions to tests functionalities

## Testing Environment Llama2

Use curl to test the Llama2 Service
```
curl -X POST -H "Content-Type: application/json" -d '{
  "system_message": "You are a helpful assistant",
  "user_message": "Generate a list of 5 funny dog names",
  "max_tokens": 100
}' http://127.0.0.1:7860/llama
```