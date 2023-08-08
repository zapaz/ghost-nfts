// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {DeployERC6551Registry} from "script/deploy/DeployERC6551Registry.s.sol";
import {DeployERC6551Account} from "script/deploy/DeployERC6551Account.s.sol";
import {DeployHi} from "script/deploy/DeployHi.s.sol";

contract DeployAll is DeployERC6551Registry, DeployERC6551Account, DeployHi {
    function run() public override(DeployERC6551Registry, DeployERC6551Account, DeployHi) {
        deploy("ERC6551Registry");
        deploy("ERC6551Account");
        deploy("Hi");
    }
}
