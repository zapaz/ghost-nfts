// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console} from "forge-std/Test.sol";
import {GhostNFTs} from "src/GhostNFTs.sol";
import {SimpleNFT} from "src/mocks/SimpleNFT.sol";

contract GhostNFTsTest is Test {
    address owner = makeAddr("owner");
    address entryPoint;

    uint256 chainId;
    address collection;
    uint256 tokenId;
    string tokenURI;

    GhostNFTs ghostNFTs;
    SimpleNFT simpleNFT;

    function setUp() public {
        entryPoint = address(this);

        ghostNFTs = new GhostNFTs(entryPoint);
        simpleNFT = new SimpleNFT();

        chainId = block.chainid;
        collection = address(simpleNFT);
        tokenId = 42;
        tokenURI = "URI";

        simpleNFT.safeMint(owner, tokenId);
    }

    function test_syncToken() public {
        uint256 _ghostTokenId = ghostNFTs.syncTokenId(chainId, collection, tokenId);
        assert(ghostNFTs.syncLastTimestamp(_ghostTokenId) == 0);

        uint256 ghostTokenId_ = ghostNFTs.syncToken(chainId, collection, tokenId);

        assert(ghostTokenId_ == _ghostTokenId);
        assert(ghostNFTs.syncLastTimestamp(ghostTokenId_) > 0);
    }

    function test_syncToken_twice() public {
        ghostNFTs.syncToken(chainId, collection, tokenId);

        vm.expectRevert();
        ghostNFTs.syncToken(chainId, collection, tokenId);
    }
}
