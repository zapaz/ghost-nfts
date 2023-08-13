---
marp: true
theme: default
backgroundColor: #fff
paginate: true
footer: "Ghost NFTs - ETHGlobal SuperHack 2023"
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
- GhostNFTs communicates from any chain to the chain of the original NFT with the help of inter-blockchain communication service like:
  LayerZero, Hyperlane or Chainlink CCIP
- GhostNFTs only communication function is `ghostSync`, that enable to propagate NFT metadata (or ghostData) threw chains
- ghostData is only synced / updated when timespamp is bigger thant last one
- Only orginal NFT chain can update ghostData timestamp, with online NFT data and snapshot timestamp

---

### Ghost NFTs Properties (3/3)

- GhostData have fixed fields : chainId, collection address, tokenId and ghostId (a combination of 3 previous ones)
- GhostData, for this first version, has 3 snapshops data fields : owner, uri and timestamp (i.e. last timestamp of the snapshot data on the original chain)
