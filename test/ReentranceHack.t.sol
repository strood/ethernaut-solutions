// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Reentrance.sol";
import "../src/ReentranceHack.sol";

// Issue w/ over/underflow in this test, script works fine
contract ReentranceHackTest is Test {
  Reentrance public reentranceContract;
  ReentranceHack public reentranceHackContract;
  address jon = address(0x1);
  address tim = address(0x2);
  receive() external payable {}

  function setUp() public {

    vm.startPrank(jon);
    vm.deal(jon, 5 ether);
    reentranceContract = new Reentrance();
    // Seed w/ value we want to drain
    (bool result,) = address(payable(reentranceContract)).call{value: 2 ether}("");
    vm.stopPrank();

    // Tim will own the attacker
    vm.startPrank(tim);
    vm.deal(tim, 5 ether);

    reentranceHackContract = new ReentranceHack(address(payable(reentranceContract)));
    vm.stopPrank();
  }

  function testAttack() public {
    
    vm.startPrank(tim);
    emit log_uint(address(tim).balance);
    assertTrue(address(tim).balance == 5 ether);

    emit log_uint(reentranceContract.balanceOf(address(reentranceHackContract))); // FFS
      // run this you see we get all the funds, need to 
    emit log_uint(address(reentranceContract).balance);
    reentranceHackContract.abuseTarget{ value: 1e18 }();
    // reentranceHackContract.getFunds();
    // emit log_uint(address(tim).balance);
    emit log_uint(address(reentranceHackContract).balance);
    emit log_uint(address(reentranceContract).balance);
    // emit log_uint(address(this).balance);
    // assertTrue(address(reentranceHackContract).balance == 3 ether);
    assertTrue(address(reentranceContract).balance == 0);

  }
}