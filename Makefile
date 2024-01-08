build:
	docker build -t deitos-base-image ./base
	docker build -t deitos-master-image ./master
	docker build -t deitos-worker-image ./worker
	docker build -t deitos-history-image ./history
	docker build -t deitos-jupyter-image ./jupyter
	docker build -t deitos-llama2-image ./llama2	
	docker build -t deitos-node-image ./substrate	
	docker build -t deitos-client-image ./deitos-client				