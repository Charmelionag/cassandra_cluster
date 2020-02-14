#!/bin/bash

service ssh start

sleep 5

echo "cassandra-$ID" | tee /etc/hostname
echo -e "\n172.19.0.10\tcassandra-1\n172.19.0.11\tcassandra-2\n172.19.0.12\tcassandra-3" | tee --append /etc/hosts

sed -i -e "s/^cluster_name.*/cluster_name: 'Cassandra Cluster'/" \
       -e "s/- seeds:.*/- seeds: \"cassandra-1\"/" \
       -e "s/^rpc_address:.*/rpc_address: 0\.0\.0\.0/" \
       -e "s/^endpoint_snitch:.*/endpoint_snitch: RackInferringSnitch/" \
       -e "s/^listen_address:.*/listen_address: cassandra-$ID/" \
       -e "s/^# broadcast_rpc_address:.*/broadcast_rpc_address: 172\.19\.0\.255/" /etc/cassandra/cassandra.yaml

sleep $WAIT
cassandra -fR
