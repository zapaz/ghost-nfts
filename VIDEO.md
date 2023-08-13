---
marp: true
theme: default
backgroundColor: #fff
paginate: true
footer: 'Ghost NFTs - ETHGlobal SuperHack 2023'
---

# Ghost NFTs

## _Enabling multichain NFTs_

---

# Vision

###  _NFTs should be multichain: you own an NFT on one chain, you should be able to own it on any other chains._

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

---

# Ghost NFTs - Basic rules

To ensure coherent syncing of ownership and metadata over chains, 3 basic rules are defined for a GhostRegistry receving a `ghostSync` message:

1/ when received by the original chain of the NFT:
Ghost Data is updated with current onchain NFT data: owher, tokenURI and timestamp, then replied back to sender

2/ when received on another chain

2.1/ and received timestamp is less recent than registered one, nothing is updated localy, but more recent local Ghost Data is sent back to sender

2.2/ and received timestamp is more recent than registered one, Ghost Data received is registered, with no reply to sender

---

# SmartContract

- A reference smartcontract implementation in solidity is available here : [GhostNFTs.sol](https://github.com/zapaz/ghost-nfts/blob/main/src/GhostNFTs.sol)

- Local demo via foundry tests can be run on [GhostNFTs repo](https://github.com/zapaz/ghost-nfts).

- Inter-chain communication with LayerZero is still under devlopment

---

# Contact

Ξ zapaz.eth
@ alain@kredeum.com
X [@papaz](https://twitter.com/papaz)
