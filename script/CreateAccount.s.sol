// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Script.sol";

import {ERC6551Registry} from "src/erc6551/ERC6551Registry.sol";
import {ERC6551Account} from "src/erc6551/ERC6551Account.sol";
import {ReadWriteJson} from "@forge-deploy-lite/ReadWriteJson.sol";

contract CreateAccount is Script, ReadWriteJson {
    // ENS NFT for zapaz.eth
    uint256 public constant CHAIN_ID = 1;
    address public constant ENS_REGISTRAR = 0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85;
    uint256 public constant TOKEN_ID = 98115882407743058088175791351085928933916884050752988623537654260341623817536;

    uint256 constant SALT = 42;

    ERC6551Registry erc6551Registry;

    function run() public {
        // Create zapaz.eth NFT account

        address implementation = readAddress("ERC6551Account");

        erc6551Registry = ERC6551Registry(readAddress("ERC6551Registry"));

        vm.startBroadcast();

        address account = erc6551Registry.createAccount(implementation, CHAIN_ID, ENS_REGISTRAR, TOKEN_ID, SALT, "");

        vm.stopBroadcast();

        console.log("run ~ account:", account);
    }
}
