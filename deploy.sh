#!/bin/sh

forge script --rpc-url optimism-goerli script/deploy/DeployGhostNFTs.s.sol --broadcast --sender $ETH_FROM
# forge script --rpc-url $1 script/deploy/DeployGhostNFTs.s.sol --broadcast --sender $ETH_FROM
# forge script --rpc-url $1 script/deploy/Deploy$2.s.sol --broadcast --sender $ETH_FROM
