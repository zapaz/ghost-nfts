// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {DeployLite} from "forge-deploy-lite/DeployLite.sol";
import {ERC6551Registry} from "src/erc6551/ERC6551Registry.sol";

contract DeployERC6551Registry is DeployLite {
    function deployERC6551Registry() public returns (address erc6551Registry) {
        vm.startBroadcast();

        erc6551Registry = address(new ERC6551Registry());

        vm.stopBroadcast();
    }

    function run() public virtual {
        deploy("ERC6551Registry");
    }
}
