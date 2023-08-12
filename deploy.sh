#!/bin/sh

# forge script --rpc-url base-goerli script/deploy/DeployPingPong.s.sol --broadcast --verify --sender $ETH_FROM
forge script --rpc-url optimism-goerli script/deploy/DeployPingPong.s.sol --broadcast --verify --sender $ETH_FROM

# forge script --rpc-url optimism-goerli script/deploy/DeployGhostNFTs.s.sol --broadcast --verify --sender $ETH_FROM
# forge script --rpc-url $1 script/deploy/DeployGhostNFTs.s.sol --broadcast --verify --sender $ETH_FROM
# forge script --rpc-url $1 script/deploy/Deploy$2.s.sol --broadcast --verify --sender $ETH_FROM
