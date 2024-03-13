build:
	docker build -t deitos-lite-base-image ./base
	docker build -t deitos-lite-master-image ./master
	docker build -t deitos-lite-worker-image ./worker
	docker build -t deitos-lite-history-image ./history		
	docker build -t deitos-node-image ./substrate		