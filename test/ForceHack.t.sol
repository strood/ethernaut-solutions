// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/ForceHack.sol";

contract ForceHackTest is Test {
  ForceHack public forceHackContract;
  address public targetAddress = 0xD710C5AD4bF0e8866F8Aa15F223c3ee355d6e32B;
  function setUp() public {
    forceHackContract = new ForceHack();
  }


  function testAttack() public {
    // Fund the contract then call it with our target
    address steve = address(0x1);
    vm.startPrank(steve);
    vm.deal(steve, 1 ether);

    emit log_uint(steve.balance);

    (bool sent, ) = address(forceHackContract).call{value: 0.7 ether}("");

    emit log_uint(address(forceHackContract).balance);

    forceHackContract.destroy(targetAddress);

    assertEq(address(targetAddress).balance, 0.7 ether);
    emit log_uint(address(targetAddress).balance);
  }
}