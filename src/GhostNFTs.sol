// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {console} from "forge-std/Test.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {IGhostNFTs} from "./IGhostNFTs.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GhostNFTs registers one original NFT as a ghost NFT with these properties :
// - GhostNFTs singleton has the same deterministic address on all chains
// - GhostNFTs is an ERC721 Metadata NFT collection
// - ghost NFT can be registered on same or another evm chain than original NFT
// - ghost NFT owner is set to NFT owner AT a specific block (and timestamp) of original chain
// - ghost NFT tokenId is equal to the hash of chainId, collection address and tokenId of original NFT
// - when original NFT collection is ERC721Metadata : ghost NFT tokenURI is equal original NFT tokenURI
// - GhostNFTs communicates one by one with the help of inter-blockchain communication service
//   (LayerZero, Hyperlane or Chainlink CCIP)
// - GhostNFTs could be combined with ERC6515 registry...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
contract GhostNFTs is IGhostNFTs, ERC721, ERC721URIStorage {
    address public immutable entryPoint;

    struct TokenData {
        uint256 ghostTokenId;
        uint256 chainId;
        address collection;
        uint256 tokenId;
        address owner;
        string uri;
        uint256 timestamp;
    }

    mapping(uint256 => uint256) public syncLastTimestamp;

    constructor(address entryPoint_) ERC721("Ghost NFTs", "GHOST") {
        entryPoint = entryPoint_;
    }

    modifier onlyRegistry() {
        require(msg.sender == address(this) || msg.sender == entryPoint, "Only registry or entry point");
        _;
    }

    function syncToken(uint256 chainId, address collection, uint256 tokenId)
        public
        override(IGhostNFTs)
        returns (uint256)
    {
        require(chainId > 0, "Wrong chain ID");
        require(collection != address(0), "Bad collection");

        uint256 ghostTokenId = syncTokenId(chainId, collection, tokenId);
        TokenData memory tokenData = TokenData(ghostTokenId, chainId, collection, tokenId, address(0), "", 0);

        return _syncToken(_getTokenData(tokenData));
    }

    function syncTokenId(uint256 chainId, address collection, uint256 tokenId)
        public
        pure
        override(IGhostNFTs)
        returns (uint256)
    {
        return uint256(keccak256(abi.encode(chainId, collection, tokenId)));
    }

    function _tuple(TokenData memory t)
        internal
        pure
        returns (uint256, uint256, address, uint256, address, string memory, uint256)
    {
        return (t.ghostTokenId, t.chainId, t.collection, t.tokenId, t.owner, t.uri, t.timestamp);
    }

    function _getTokenData(TokenData memory tokenData) internal view returns (TokenData memory) {
        (
            uint256 ghostTokenId,
            uint256 chainId,
            address collection,
            uint256 tokenId,
            address owner,
            string memory uri,
            uint256 timestamp
        ) = _tuple(tokenData);

        if (chainId == block.chainid) {
            owner = ERC721(collection).ownerOf(tokenId);
            uri = ERC721(collection).tokenURI(tokenId);
            timestamp = block.timestamp;
        }

        return (TokenData(ghostTokenId, chainId, collection, tokenId, owner, uri, timestamp));
    }

    function _syncToken(TokenData memory tokenData) internal returns (uint256) {
        // if (tokenData.chainId == block.chainid) {
        //     _syncTokenLocal(tokenData);
        // } else {
        //     _syncTokenSend(tokenData);
        // }
        _syncTokenSend(tokenData);
        return tokenData.ghostTokenId;
    }

    function _syncTokenSend(TokenData memory tokenData) internal onlyRegistry {
        bytes memory data = abi.encode(tokenData);

        // console.log("_syncTokenRequest:", tokenData.chainId);
        // console.logBytes(data);

        // sendMessage(tokenData.chainId, data);
        _syncTokenReceive(data);
    }

    function _syncTokenReceive(bytes memory data) internal onlyRegistry {
        // console.log("receiveMessage:");
        // console.logBytes(data);

        TokenData memory tokenData = abi.decode(data, (TokenData));
        _syncTokenLocal(tokenData);
    }

    function _syncTokenLocal(TokenData memory tokenData) internal {
        (
            uint256 ghostTokenId,
            uint256 chainId,
            address collection,
            uint256 tokenId,
            address owner,
            string memory uri,
            uint256 timestamp
        ) = _tuple(tokenData);
        require(chainId == block.chainid, "Wrong chain");
        require(collection != address(0), "No collection");
        require(ghostTokenId == syncTokenId(chainId, collection, tokenId), "Wrong Ghost ID");
        require(syncLastTimestamp[ghostTokenId] < timestamp, "Bad time");

        syncLastTimestamp[ghostTokenId] = timestamp;

        if (_exists(ghostTokenId)) {
            address lastOwner = ownerOf(ghostTokenId);
            if (lastOwner != owner) {
                safeTransferFrom(lastOwner, owner, ghostTokenId);
            }
            if (keccak256(abi.encodePacked(tokenURI(ghostTokenId))) != keccak256(abi.encodePacked(uri))) {
                _setTokenURI(ghostTokenId, uri);
            }
        } else {
            _safeMint(owner, ghostTokenId);
            _setTokenURI(ghostTokenId, uri);
        }
    }

    // STANDARD FUNCTIONS

    function _burn(uint256 ghostTokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(ghostTokenId);
    }

    function tokenURI(uint256 ghostTokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(ghostTokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
