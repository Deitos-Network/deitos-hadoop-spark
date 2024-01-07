build:
	docker build -t deitos-hadoop-base ./base
	docker build -t deitos-hadoop-master ./master
	docker build -t deitos-hadoop-worker ./worker
	docker build -t deitos-hadoop-history ./history
	docker build -t deitos-hadoop-jupyter ./jupyter
	docker build -t deitos-hadoop-llama2 ./llama2	
	docker build -t deitos-node ./substrate	
	docker build -t deitos-client ./deitos-client				