#!/bin/bash

echo "Starting deitos-verifier ..."

DV_PORT="4040" HDFS_URI="http://master.deitos.network:50070/webhdfs/v1/data/deitos"  /node-template/deitos-verifier/target/release/deitos-verifier

echo "Starting deitos-node ..."

/usr/local/bin/deitos-node --base-path /tmp/alice --chain local --alice --port 30333 --rpc-port 9944 --node-key 0000000000000000000000000000000000000000000000000000000000000001 --validator --force-authoring --unsafe-rpc-external --rpc-cors=all --execution-offchain-worker both

while true; do sleep 1000; done
