---
marp: true
theme: default
backgroundColor: #fff
paginate: true
footer: 'Ghost NFTs - ETHGlobal SuperHack 2023'
---

## ETHGlobal SuperHack 2023

# Ghost NFTs

## _Enabling multichain NFTs_

---

### Summary

1- Solo / Team
2 - Use Cases
3 - Ghost NFTs
4 - Demo
5 - Future
6 - Contact

---

### Solo / Team

- Zapaz :
  - co-founder and lead dev @Kredeum
  - ETHGlobal finalist early 2021 with Best AAVE FlashLoan Project
  - currently Formal Verification Audits contests with Certora for AAVE, GMX
- Kredeum :
  - team of 5 Web2 entrepreneurs passionate about Web3
  - Kredeum NFT Factory : existing Open Source platform with multichain NFTs
  (BUT only for Soulbound NFT)
  - Grants via GitCoin, Polygon, Swarm and The Graph

---

### Use Cases

_Vision : NFTs should be multichain: you own an NFT on one chain, you should be able to own it on any other chains._

Typically for services like ENS, PFP or Token Gating

---

# Ghost NFTs

GhostNFTs is a registery of NFTs, available on any chain.

A ghost NFT is a lite copy of the original NFT: containing it's two main properties: owner and tokenURI plus the timestamp of the snapshot.

Ghost NFTs are synced threw different networks with the help of inter-blockchain communication service like: LayerZero, Hyperlane or Chainlink CCIP

With Ghost NFTs data, most of NFT service like ENS, PFP or Token Gating can be use on any other chain

---

# Ghost Data

With this structure synced threw chains

```solidity
    struct GhostData {
        uint256 ghostId;
        uint256 chainId;
        address collection;
        uint256 tokenId;
        address owner;
        string uri;
        uint256 timestamp;
    }
```

---

### Ghost NFTs Properties (1/3)

GhostNFTs is a registery of NFTs with these properties :

- GhostNFTs is an ERC721 Metadata NFT collection
- one GhostNFTs singleton may exists on each evm chain with same deterministic address
- ghost NFT can be registered on same or another evm chain than original NFT
- ghost NFT owner is synced to NFT owner AT a specific timestamp of original chain
- ghost NFT tokenId (also named ghostId) is a hash of chainId, collection address and tokenId of original NFT

---

### Ghost NFTs Properties (2/3)

- when original NFT collection is ERC721Metadata : ghost NFT tokenURI is original NFT tokenURI
- GhostNFTs communicates from any chain to the chain of the original NFT  with the help of inter-blockchain communication service like:
  LayerZero, Hyperlane or Chainlink CCIP
- GhostNFTs only communication function is `ghostSync`, that enable to propagate NFT metadata (or ghostData) threw chains
- ghostData is only synced / updated when timespamp is bigger thant last one
- Only orginal NFT chain can update ghostData timestamp, with online NFT data and snapshot  timestamp

---

### Ghost NFTs Properties (3/3)

- GhostData have fixed fields : chainId, collection address, tokenId and ghostId (a combination of 3 previous ones)
- GhostData, for this first version, has 3 snapshops data fields : owner, uri and timestamp (i.e. last timestamp of the snapshot data on the original chain)

---

# SmartContract

- Reference smartcontract implementation is available here : [GhostNFTs.sol](https://github.com/zapaz/ghost-nfts/blob/main/src/GhostNFTs.sol)

- Local demo via foundry scripts can be run on [GhostNFTs repo](https://github.com/zapaz/ghost-nfts).


_Currently multi-chain communication is only simulated, tests with LayerZero are coming_

---

### Future 1/2

- Continue testing and development multichain
- Implement ENS specific feature
(as ENS is not an ERC721 metadata collection)
- Full implemention with at least one communication layer
- Propose Ghost NFTs as an EIP
- GhostNFTs could be combined with ERC6551 registry...
- enhance multichain transfer

---

### Future 2/2

- propose UI requirement : Ghost NFT could be forced to be « grey », with no color
- Implement in Kredeum Factory
- develop transferEverywere function inside ERC6551 Bound Accounts
- Implement specific feature to any specific NFT collection

---

### Contact

Ξ zapaz.eth
@ alain@kredeum.com
X [@papaz](https://twitter.com/papaz)
