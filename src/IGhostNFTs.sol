// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGhostNFTs {
    function syncLastTimestamp(uint256 ghostId) external returns (uint256 syncLastTimestamp);

    function syncGhost(uint256 chainId, address collection, uint256 tokenId) external returns (uint256 ghostId);

    function getGhostId(uint256 chainId, address collection, uint256 tokenId) external returns (uint256 ghostId);
}
