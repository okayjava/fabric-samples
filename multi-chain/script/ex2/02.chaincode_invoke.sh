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
docker exec -e "CORE_PEER_ADDRESS=peer0.org1.fastcampus.co.kr:7051" cli1 peer chaincode invoke -o orderer.fastcampus.co.kr:7050 -C mychannel -n ex2 -c '{"Args":["invoke","a","b","50"]}'