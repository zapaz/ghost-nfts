// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

import {DeployLite} from "@forge-deploy-lite/DeployLite.sol";
import {OmniMessage} from "src/layerzero/OmniMessage.sol";
// import {ReadWriteJson} from "@forge-deploy-lite/ReadWriteJson.sol";

contract DeployOmniMessage is Script, DeployLite {
    function deployOmniMessage() public returns (address omniMessage) {
        address lzEndpoint = readAddress("LZEndpoint");
        console.log("deployOmniMessage ~ lzEndpoint:", lzEndpoint);

        vm.startBroadcast();

        omniMessage = address(new OmniMessage(lzEndpoint));

        vm.stopBroadcast();
    }

    function run() public virtual {
        deploy("OmniMessage");
    }
}
