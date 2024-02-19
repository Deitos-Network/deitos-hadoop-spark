docker rm deitos-worker1 deitos-master deitos-metastore deitos-client
docker image prune -a 
docker volume rm deitos-ip_datanode1 deitos-ip_metastore deitos-ip_namenode deitos-ip_namesecondary 
docker builder prune -a