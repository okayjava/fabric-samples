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
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n sacc -c '{"Args":["get","key730"]}'
