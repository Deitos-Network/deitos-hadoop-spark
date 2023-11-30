build:
	docker build -t deitos-hadoop-base ./base
	docker build -t deitos-hadoop-master ./master
	docker build -t deitos-hadoop-worker ./worker
	docker build -t deitos-hadoop-history ./history
	docker build -t deitos-hadoop-jupyter ./jupyter