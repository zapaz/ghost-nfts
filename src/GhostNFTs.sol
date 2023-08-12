// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// import {console} from "forge-std/Test.sol";

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {IGhostNFTs} from "./IGhostNFTs.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// GhostNFTs registers one original NFT as a ghost NFT with these properties :
// - GhostNFTs is an ERC721 Metadata NFT collection
// - one GhostNFTs singleton may exists on each evm chains with same deterministic address
// - ghost NFT can be registered on same or another evm chain than original NFT
// - ghost NFT owner is set to NFT owner AT a specific block (and timestamp) of original chain
// - ghost NFT tokenId is equal to the hash of chainId, collection address and tokenId of original NFT
// - when original NFT collection is ERC721Metadata : ghost NFT tokenURI is equal original NFT tokenURI
// - GhostNFTs communicates one by one with the help of inter-blockchain communication service
//   (LayerZero, Hyperlane or Chainlink CCIP)
// - GhostNFTs only communication function is ghostSync
// - Only NFT chain can update ghostData, with real online (snapshop at a timestamp) data
// - GhostData have fixed fields : chainId, collection address, tokenId and gohostId (a combination of 3 previeous ones)
// - GhostData have snapshop data fields, for this first version : owner, uri and timestamp (i.e. last timestamp of the snapshot data on the original chain)
// - GhostNFTs could be combined with ERC6515 registry...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
contract GhostNFTs is IGhostNFTs, ERC721, ERC721URIStorage {
    address public immutable entryPoint;

    struct GhostData {
        uint256 ghostId;
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

    function syncGhost(uint256 chainId, address collection, uint256 tokenId)
        public
        override(IGhostNFTs)
        returns (uint256)
    {
        require(chainId > 0, "Wrong chain ID");
        require(collection != address(0), "Bad collection");

        uint256 ghostId = getGhostId(chainId, collection, tokenId);
        GhostData memory ghostData = GhostData(ghostId, chainId, collection, tokenId, address(0), "", 0);

        return _syncGhost(_getGhostData(ghostData));
    }

    function getGhostId(uint256 chainId, address collection, uint256 tokenId)
        public
        pure
        override(IGhostNFTs)
        returns (uint256)
    {
        return uint256(keccak256(abi.encode(chainId, collection, tokenId)));
    }

    function _tuple(GhostData memory t)
        internal
        pure
        returns (uint256, uint256, address, uint256, address, string memory, uint256)
    {
        return (t.ghostId, t.chainId, t.collection, t.tokenId, t.owner, t.uri, t.timestamp);
    }

    function _getGhostData(GhostData memory ghostData) internal view returns (GhostData memory) {
        (
            uint256 ghostId,
            uint256 chainId,
            address collection,
            uint256 tokenId,
            address owner,
            string memory uri,
            uint256 timestamp
        ) = _tuple(ghostData);

        if (chainId == block.chainid) {
            owner = ERC721(collection).ownerOf(tokenId);
            uri = ERC721(collection).tokenURI(tokenId);
            timestamp = block.timestamp;
        }

        return (GhostData(ghostId, chainId, collection, tokenId, owner, uri, timestamp));
    }

    function _syncGhost(GhostData memory ghostData) internal returns (uint256) {
        // if (ghostData.chainId == block.chainid) {
        //     _syncGhostLocal(ghostData);
        // } else {
        //     _syncGhostSend(ghostData);
        // }
        _syncGhostSend(ghostData);
        return ghostData.ghostId;
    }

    function _syncGhostSend(GhostData memory ghostData) internal onlyRegistry {
        bytes memory data = abi.encode(ghostData);

        // console.log("_syncGhostRequest:", ghostData.chainId);
        // console.logBytes(data);

        // sendMessage(ghostData.chainId, data);
        _syncGhostReceive(data);
    }

    function _syncGhostReceive(bytes memory data) internal onlyRegistry {
        // console.log("receiveMessage:");
        // console.logBytes(data);

        GhostData memory ghostData = abi.decode(data, (GhostData));
        _syncGhostLocal(ghostData);
    }

    function _syncGhostLocal(GhostData memory ghostData) internal {
        (
            uint256 ghostId,
            uint256 chainId,
            address collection,
            uint256 tokenId,
            address owner,
            string memory uri,
            uint256 timestamp
        ) = _tuple(ghostData);
        require(chainId == block.chainid, "Wrong chain");
        require(collection != address(0), "No collection");
        require(ghostId == getGhostId(chainId, collection, tokenId), "Wrong Ghost ID");
        require(syncLastTimestamp[ghostId] < timestamp, "Bad time");

        syncLastTimestamp[ghostId] = timestamp;

        if (_exists(ghostId)) {
            address lastOwner = ownerOf(ghostId);
            if (lastOwner != owner) {
                safeTransferFrom(lastOwner, owner, ghostId);
            }
            if (keccak256(abi.encodePacked(tokenURI(ghostId))) != keccak256(abi.encodePacked(uri))) {
                _setTokenURI(ghostId, uri);
            }
        } else {
            _safeMint(owner, ghostId);
            _setTokenURI(ghostId, uri);
        }
    }

    // STANDARD FUNCTIONS

    function _burn(uint256 ghostId) internal override(ERC721, ERC721URIStorage) {
        super._burn(ghostId);
    }

    function tokenURI(uint256 ghostId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(ghostId);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
