![deitos.logo](deitos.logo.png)
## 🚧🚧 Under Construction 🚧🚧

# Deitos Network for Infraestructure Provider

Deitos incorporates Substrate's blockchain technology to transform the consumption of Big Data services. 

This project shows how a set of containers can be deployed on the side of an infrastructure provider to start a Deitos Node and a set of Hadoop-based services (Hadoop / Spark / Hive), it also shows the deployment of a Jupyter-based client that can use the services offered by the infrastructure provider.

## Infrastructure provider services


On the side of the infrastructure provider, a Hadoop Cluster is installed, with 1 NameNode and 2 Datanodes, also, a Spark Cluster is installed with 1 Driver and 2 Slaves. All the security of the ecosystem is implemented over Kerberos and LDAP. The users that can access the cluster require to be created in Kerberos, who is responsible for their authentication, the LDAP server serves to organize the structure of Groups and Users on which define the permissions scheme in the directory structure that is created in the HDFS file system by the infrastructure provider.

This Docker instance also provides a Jupyter-based service to test the functionality of the services offered through a sample Python-based notebook.

### Software Used

* [Hadoop 3.3.6](https://hadoop.apache.org/)
* [Hive 3.1.3](http://hive.apache.org/)
* [Spark 3.4.1](https://spark.apache.org/)
* [Jupyter 3.4.3](https://jupyter.org/)
* [Llama-2 7B](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF)


### Starting Infraestructure Provider Services

It is required to start the Services in the Infrastructure Provider, in this sense, it is necessary to build the docker images and invoke the corresponding startup script.

Build de docker images:
```
make
```
![Build Docker Images](build-docker-images.png)


Start the Docker containers in Infraestructure Provide:
```
./start-ip.sh
```
![Start Services in Infraestructure Providee](start-services-ip.png)

It is necessary to verify if the services have been started correctly, for this we will enter the node master of the Docker deployment, and verify the status of the data nodes that make up the Hadoop cluster, for this we execute the following command:

1. Enter into master node using the command in your bash session: 
```
docker exec -it deitos-master bash
```
2. Execute HDFS command that gives a detailed report on the health status of the Cluster.:
```
hdfs dfsadmin -report 
```
You should get a output similar to the next:
![HDFS Admin Report](hdfs-report.png)

In the attached image you can verify that the cluster is composed by  2 datanodes and both are alive, one of them is called worker1.deitos.network.

Please note that the process of starting the hadoop cluster may take some time, depending on the hardware resources of your machine.

### Checking Other Services

Several services run within the Hadoop cluster, such as the Yarn resource scheduler and the Spark distributed scripting engine, and you can view their running status using the web browser and accessing the corresponding monitoring consoles.

For YARN service status 

ResourceManager: http://localhost:8088

![YARN Console](yarn-console.png)

master: http://localhost:8080

![SPARK Console](spark-console.png)

On the infrastructure provider side, you can access the Jupyter programming interface, with which you can test the use of Spark / Hadoop and Hive through a Notebook example, once validated in the system. 

URL: http://localhost:8888
example: [jupyter/notebook/pyspark.ipynb](http://localhost:8888/notebooks/pyspark.ipynb)

![Jupyter Main Window](jupyter-main-window.png)

## Client services

Docker instance  provides a Jupyter-based service to test the functionalities of the services offered through a sample Python-based notebook, and also allows working on command line to test different instructions to use the services offered by the infrastructure provider.

### Starting Client

To start the client services, run the corresponding script command:
```
./start-client.sh
```

![Start Services Client](start-services-client.png)


### Testing Services Hadoop using Command-line

To test the services we will need to login to the client docker node, validate in kerberos using a keytab file corresponding to a test user that was created during the installation process.

Enter into deitos-client node using the command in your bash session: 
```
docker exec -it deitos-client bash
```

To verify access to the services, we authenticate to kerberos with the user named test_user and run a command to list the directories in the root of the HDFS file system.

```
# Autheticate User
kinit -kt /home/jovyan/keytabs/current-jupyter.keytab test_user/$(hostname -f)@DEITOS.NETWORK

# Make ls to HDFS Filesystem
hdfs dfs -ls /data/test_user
```

![List HDFS Filesystem](list-hdfs.png)

It is possible to upload a sample file to a specific path in the HDFS file system hosted on the client node. We can use the command:
```
hdfs dfs -put test/test.txt /data/test_user
```

Show results of Execution:
![Command-line Results](commandline-results.png)


### Testing Services Hadoop using WebHDFS

Among the services deployed in the Infrastructure Provider is the WebHDFS Rest API, which allows performing operations with the HDFS file system. To do this, the test_user will be validated in Kerberos, obtaining a Delegation Token that can later be used to list directories in a specific path of the file system and upload a file to a specific location.

The examples and tests presented below are performed using the curl command, which provides a lot of flexibility.

For make this activies, in necessary enter in deitos-client node using the command in your bash session: 
```
docker exec -it deitos-client bash
```

To interact with the API execute the following sequence of commands using the curl command, note that each instruction is documented with a comment indicating the operation and usefulness of the command:
```
# Autheticate User
kinit -kt /home/jovyan/keytabs/current-jupyter.keytab test_user/$(hostname -f)@DEITOS.NETWORK

# Get Delegation Token
curl -v -i -k --negotiate -u : "https://master.deitos.network:50470/webhdfs/v1/data/test_user?op=GETDELEGATIONTOKEN"


# List Directory
curl -v -i -k "https://master.deitos.network:50470/webhdfs/v1/?delegation=<token>&op=LISTSTATUS"

# Define Upload Operation to API - The Response is a Redirect Address to Execute the final Operation
curl -v -i -k --negotiate -u : -X PUT "https://master.deitos.network:50470/webhdfs/v1/data/test_user/test.txt?delegation=<token>&op=CREATE"

# Upload File to the API
curl -i -k -X PUT -T test/test.txt "https://worker1.deitos.network:50075/webhdfs/v1/data/test_user/test.txt?op=CREATE&delegation=<token>&namenoderpcaddress=master.deitos.network:8020&createflag=&createparent=true&overwrite=true"
```

## Testing Services Hadoop/Spark/Hive from Jupyter Notebook

Access the Service using the Internet Browser and Open the Notebook named pyspark.ipnb

http://localhost:8889/notebooks/pyspark.ipynb

Execute the each instructions to tests functionalities (The Script show some commons functions used when work with Hadoop/Hive/Spark)

![Jupyter Notebook](jupyter-notebook.png)

## Testing Environment Llama2

Among the services configured in the infrastructure provider is a Flask-based application that uses a Llama2-based LLM model to do some very simple tasks, this section shows how to test this service using the curl command.

Enter into deitos-client node using the command in your bash session: 
```
docker exec -it deitos-client bash
```

Use curl to test the Llama2 Service
```
curl -X POST -H "Content-Type: application/json" -d '{
  "system_message": "You are a helpful assistant",
  "user_message": "Generate a list of 5 funny dog names",
  "max_tokens": 100
}' http://llama2.deitos.network:5000/llama
```

View the results:
![Llama2 Results](llama2-result.png)