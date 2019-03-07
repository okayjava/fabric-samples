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

#Install CC
#org1
docker exec -e "CORE_PEER_ADDRESS=peer0.org1.fastcampus.co.kr:7051" cli1 peer chaincode install -n sacc -v 1.0 -p github.com/sacc
docker exec -e "CORE_PEER_ADDRESS=peer1.org1.fastcampus.co.kr:7051" cli1 peer chaincode install -n sacc -v 1.0 -p github.com/sacc

#org2
docker exec -e "CORE_PEER_ADDRESS=peer0.org2.fastcampus.co.kr:7051" cli2 peer chaincode install -n sacc -v 1.0 -p github.com/sacc
docker exec -e "CORE_PEER_ADDRESS=peer1.org2.fastcampus.co.kr:7051" cli2 peer chaincode install -n sacc -v 1.0 -p github.com/sacc

#Instantiate CC
docker exec -e "CORE_PEER_ADDRESS=peer0.org1.fastcampus.co.kr:7051" cli1 peer chaincode instantiate -o orderer.fastcampus.co.kr:7050 -C mychannel -n sacc -v 1.0 -c '{"Args":["a", "100"]}' -P "OR ('Org1MSP.member', 'Org2MSP.member')"
