// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// NFTRegistry registers one original NFT as a ghost NFT with these properties :
// - NFTRegistry singleton has the same deterministic address on all chains
// - NFTRegistry is an ERC721 Metadata NFT collection
// - ghost NFT can be registered on same or another evm chain than original NFT
// - ghost NFT owner is set to NFT owner AT a specific block (and timestamp) of original chain
// - ghost NFT tokenId is equal to the hash of chainId, collection address and tokenId of original NFT
// - when original NFT collection is ERC721Metadata : ghost NFT tokenURI is equal original NFT tokenURI
// - NFTRegistries communicates one by one with the help of inter-blockchain communication service
//   (LayerZero, Hyperlane or Chainlink CCIP)
// - this NFTRegistry could be combined with ERC6515 registry...
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
contract GhostNFTs is ERC721, ERC721URIStorage {
    address public immutable entryPoint;

    struct TokenData {
        uint256 chainId;
        address collection;
        uint256 tokenId;
        address owner;
        string uri;
        uint256 timestamp;
        uint256 ghostTokenId;
    }

    mapping(uint256 => uint256) public lastUpdateTimestamp;

    constructor(address entryPoint_) ERC721("Ghost NFTs", "GHOST") {
        entryPoint = entryPoint_;
    }

    modifier onlyRegistry() {
        require(msg.sender == address(this) || msg.sender == entryPoint, "Only registry, local or remote");
        _;
    }

    function getTokenData(address collection, uint256 tokenId) public view returns (TokenData memory tokenData) {
        return (
            TokenData(
                block.chainid,
                collection,
                tokenId,
                ERC721(collection).ownerOf(tokenId),
                ERC721(collection).tokenURI(tokenId),
                block.timestamp,
                uint256(keccak256(abi.encode(block.chainid, collection, tokenId)))
            )
        );
    }

    function _encodeTokenData(address collection, uint256 tokenId) internal view returns (bytes memory) {
        return abi.encode(getTokenData(collection, tokenId));
    }

    function _decodeTokenData(bytes memory data) internal pure returns (uint256, address, string memory, uint256) {
        return abi.decode(data, (uint256, address, string, uint256));
    }

    function _setLastUpdateTimestamp(uint256 tokenId, uint256 timestamp) internal {
        lastUpdateTimestamp[tokenId] = timestamp;
    }

    function register(uint256 chainId, address collection, uint256 tokenId) public {
        // Same blockchain can get info easily
        if (chainId == block.chainid) {
            _safeMint(getTokenData(collection, tokenId));
        } else {
            getTokenDataRemote(chainId, collection, tokenId);
        }
    }

    function sendMessage(uint256 chaiId, bytes memory data) public onlyRegistry {}

    function getTokenDataRequest(uint256 chainId, address collection, uint256 tokenId) internal onlyRegistry {
        bytes memory data = abi.encode(collection, tokenId);
        sendMessage(chainId, data);
    }

    function getTokenDataAnswer(bytes memory data) public onlyRegistry {
        _safeMint(abi.decode(data, (TokenData)));
    }

    function _safeMint(TokenData memory tokenData) internal {
        _safeMint(tokenData.owner, tokenData.ghostTokenId);
        _setTokenURI(tokenData.ghostTokenId, tokenData.uri);
        _setLastUpdateTimestamp(tokenData.ghostTokenId, tokenData.timestamp);
    }

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
