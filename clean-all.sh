docker rm deitos-jupyter deitos-worker2 deitos-history deitos-worker1 deitos-master deitos-ldap-console deitos-llama2 deitos-metastore deitos-kdc deitos-node deitos-ldap 
docker image prune -a 
docker volume rm deitos-ip_datanode1 deitos-ip_datanode2 deitos-ip_metastore deitos-ip_namenode deitos-ip_namesecondary 