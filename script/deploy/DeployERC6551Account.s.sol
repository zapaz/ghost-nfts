// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {DeployLite} from "@forge-deploy-lite/DeployLite.sol";
import {ERC6551Account} from "src/erc6551/ERC6551Account.sol";

contract DeployERC6551Account is DeployLite {
    function deployERC6551Account() public returns (address erc6551Account) {
        vm.startBroadcast();

        erc6551Account = address(new ERC6551Account());

        vm.stopBroadcast();
    }

    function run() public virtual {
        deploy("ERC6551Account");
    }
}
