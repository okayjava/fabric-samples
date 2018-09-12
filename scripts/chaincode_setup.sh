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
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP"  cli peer chaincode install -n sacc -v 1.0 -p github.com/sacc

#Instantiate CC
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP"  cli peer chaincode  instantiate -o orderer.example.com:7050 -C mychannel -n sacc -v 1.0 -c '{"Args":["a", "100"]}' -P "OR ('Org1MSP.member')"
