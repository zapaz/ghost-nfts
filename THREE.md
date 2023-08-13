---
marp: true
theme: default
backgroundColor: #fff
paginate: true
footer: 'Ghost NFTs - ETHGlobal SuperHack 2023'
---

# Ghost NFTs -  Enabling multichain NFTs

### Vision : _NFTs should be multichain: you own an NFT on one chain, you should be able to own it on any other chains._

Typically for services like ENS, PFP or Token Gating

### _But exchanging these multichain NFTs is challenging! After a transfer, how to ensure same owner on every chain ?_

---

# Ghost NFTs - Registry

GhostNFTs is a registery of NFTs (quite similar to ERC6551 registry), available on any chain at a deterministic address.

It registers Ghost NFTs: a lite copy of the original NFT with Ghost Data that includes owner, tokenURI and the timestamp of the snapshot.

With Ghost Data, most of NFT service like ENS, PFP or Token Gating can be use on any other chain

---

# Ghost NFTs - Syncing

Ghost NFTs are synced threw different networks with the help of inter-blockchain messages, containing Ghost Data, with service like: LayerZero, Hyperlane or CCIP

For simplicity, only one type of message is exchanged between GhostRegistry of different chains : the `ghostSync` message  that only includes this Ghost Data :

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
