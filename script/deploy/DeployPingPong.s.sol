// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import {DeployLite} from "@forge-deploy-lite/DeployLite.sol";
import {PingPong} from "src/layerzero/PingPong.sol";
// import {ReadWriteJson} from "@forge-deploy-lite/ReadWriteJson.sol";

contract DeployPingPong is Script, DeployLite {
    function deployPingPong() public returns (address pingPong) {
        address lzEndpoint = readAddress("LZEndpoint");
        console.log("deployPingPong ~ lzEndpoint:", lzEndpoint);

        vm.startBroadcast();

        pingPong = address(new PingPong(lzEndpoint));

        vm.stopBroadcast();
    }

    function run() public virtual {
        deploy("PingPong");
    }
}
