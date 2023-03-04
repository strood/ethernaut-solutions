// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GatekeeperTwo.sol";
import "../src/GatekeeperTwoHack.sol";

contract GateKeeperTwoHackTest is Test {
  GatekeeperTwo public gatekeeperTwoContract;
  GatekeeperTwoHack public gatekeeperTwoHackContract;
  address tony = address(0x01);
  address bill = address(0x359bfB5160946a55f03c080c2DC6975C8F970d5C);

  function setUp() public {
    
    vm.startPrank(tony);
    vm.deal(tony, 5 ether);
    gatekeeperTwoContract = GatekeeperTwo(0xB1d7d82C7d62e6a90d37cADA5fd38559Bcf46d6c);
    vm.stopPrank();

  }

  function testHack() public {
    vm.startPrank(bill);
    gatekeeperTwoHackContract = new GatekeeperTwoHack(address(gatekeeperTwoContract));
    require(gatekeeperTwoContract.entrant() == bill);
    vm.stopPrank();

  }
}