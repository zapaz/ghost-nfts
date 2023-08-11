// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGhostNFTs {
    function syncLastTimestamp(uint256 ghostTokenId) external returns (uint256 syncLastTimestamp);

    function syncToken(uint256 chainId, address collection, uint256 tokenId) external returns (uint256 ghostTokenId);

    function syncTokenId(uint256 chainId, address collection, uint256 tokenId)
        external
        returns (uint256 ghostTokenId);
}
