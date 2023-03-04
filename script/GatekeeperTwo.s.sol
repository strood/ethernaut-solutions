// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/GatekeeperTwoHack.sol";
import "../src/GatekeeperTwo.sol";

contract GatekeeperTwoHackScript is Script {
  GatekeeperTwoHack gatekeeperTwoHackContract;
  address gatekeeperTwoContract = 0xB1d7d82C7d62e6a90d37cADA5fd38559Bcf46d6c;
  function setUp() public {}
  
  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(attacker);
    // Simple, just need to deploy
    gatekeeperTwoHackContract = new GatekeeperTwoHack(address(gatekeeperTwoContract));

    vm.stopBroadcast();
  }

}