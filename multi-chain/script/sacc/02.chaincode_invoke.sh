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

#Invoke Test
docker exec -e "CORE_PEER_ADDRESS=peer0.org1.fastcampus.co.kr:7051" cli1 peer chaincode invoke -o orderer.fastcampus.co.kr:7050 -C mychannel -n sacc -c '{"Args":["set","key730", "value180730"]}'
docker exec -e "CORE_PEER_ADDRESS=peer1.org1.fastcampus.co.kr:7051" cli1 peer chaincode invoke -o orderer.fastcampus.co.kr:7050 -C mychannel -n sacc -c '{"Args":["set","key731", "value180731"]}'
docker exec -e "CORE_PEER_ADDRESS=peer0.org2.fastcampus.co.kr:7051" cli2 peer chaincode invoke -o orderer.fastcampus.co.kr:7050 -C mychannel -n sacc -c '{"Args":["set","key732", "value180732"]}'
docker exec -e "CORE_PEER_ADDRESS=peer1.org2.fastcampus.co.kr:7051" cli2 peer chaincode invoke -o orderer.fastcampus.co.kr:7050 -C mychannel -n sacc -c '{"Args":["set","key733", "value180733"]}'
