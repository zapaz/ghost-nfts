// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {DeployLite} from "@forge-deploy-lite/DeployLite.sol";
import {Hi} from "src/Hi.sol";

contract DeployHi is DeployLite {
    function deployHi() public returns (address hi) {
        vm.startBroadcast();

        hi = address(new Hi());

        vm.stopBroadcast();
    }

    function run() public virtual {
        deploy("Hi");
    }
}
