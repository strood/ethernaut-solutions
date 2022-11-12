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
    address bob = address(0x003c44cdddb6a900fa2b585dd299e03d12fa4293bc);
    vm.startPrank(bob);
    assertEq(fallbackContract.getContribution(), 0);
    fallbackContract.contribute{value: 0.0001 ether}();
    emit log_uint(fallbackContract.getContribution());
    assertEq(fallbackContract.getContribution(), 0.0001 ether);
  }

}