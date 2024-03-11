#!/bin/bash

echo "Starting deitos-verifier ..."

export DV_PORT="4040" 
export HDFS_URI="http://master.deitos.network:50070/webhdfs/v1/data/deitos"  
/node-template/deitos-verifier/target/release/deitos-verifier &

echo "Starting deitos-gate ..."

export DG_PORT="9090" 
export DEITOS_IP="5GrwvaEF5zXb26Fz9rcQpDWS57CtERHpNehXCPcNoHGKutQY"
export DEITOS_NODE="ws://127.0.0.1:9944"
export HDFS_URI="http://127.0.0.1:50070"
/node-template/deitos-gate/target/release/deitos-gate &


echo "Starting deitos-node ..."


/usr/local/bin/deitos-node --tmp --dev --rpc-external --port 30333 --rpc-port 9944 --execution-offchain-worker both


while true; do sleep 1000; done
