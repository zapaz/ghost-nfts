// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DeployLite} from "@forge-deploy-lite/DeployLite.sol";
import {GhostNFTs} from "src/GhostNFTs.sol";

contract DeployGhostNFTs is DeployLite {
    address entryPoint = address(42);

    function deployGhostNFTs() public returns (address ghostNFTs) {
        vm.startBroadcast();

        ghostNFTs = address(new GhostNFTs(entryPoint));

        vm.stopBroadcast();
    }

    function run() public virtual {
        deploy("GhostNFTs");
    }
}
