docker run -itd \
    --name zk1 --network "net_basic" \
    -e ZOO_MY_ID=1  \
    -e ZOO_SERVERS=server.1="zk1:2888:3888" \
    -e ZOO_TICK_TIME=2000 \
    -e ZOO_INIT_LIMIT=10 \
    -e ZOO_SYNC_LIMIT=5 \
    hyperledger/fabric-zookeeper:latest


docker run -itd \
    --name kafka0 --network "net_basic" --link zk1:zk1 \
    -e KAFKA_BROKER_ID=0 \
    -e KAFKA_MIN_INSYNC_REPLICAS=1 \
    -e KAFKA_MESSAGE_MAX_BYTES=6000000 \
    -e KAFKA_REPLICA_FETCH_MAX_BYTES=6000000 \
    -e KAFKA_DEFAULT_REPLICATION_FACTOR=1 \
    -e KAFKA_ZOOKEEPER_CONNECT=zk1:2181 \
    hyperledger/fabric-kafka:latest
