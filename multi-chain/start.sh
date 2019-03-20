#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error, print all commands.
set -ev

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1

docker-compose -f docker-compose.yml down

docker-compose -f docker-compose.yml up -d 

# wait for Hyperledger Fabric to start
# incase of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
#echo ${FABRIC_START_TIMEOUT}
sleep ${FABRIC_START_TIMEOUT}

# Create the channel
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/msp/users/Admin@org1.fastcampus.co.kr/msp" cli1 peer channel create -o orderer.fastcampus.co.kr:7050 -c mychannel -f /etc/hyperledger/configtx/channel.tx

# Join peer0.org1.fastcampus.co.kr to the channel.
docker exec -e "CORE_PEER_ADDRESS=peer0.org1.fastcampus.co.kr:7051" cli1 peer channel join -b mychannel.block
docker exec -e "CORE_PEER_ADDRESS=peer1.org1.fastcampus.co.kr:7051" cli1 peer channel join -b mychannel.block

# Join org2
docker exec -e "CORE_PEER_ADDRESS=peer0.org2.fastcampus.co.kr:7051" cli2 peer channel join -b mychannel.block
docker exec -e "CORE_PEER_ADDRESS=peer1.org2.fastcampus.co.kr:7051" cli2 peer channel join -b mychannel.block
