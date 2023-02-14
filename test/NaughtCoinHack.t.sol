// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/NaughtCoin.sol";
import "../src/NaughtCoinHack.sol";

contract NaughtCoinHackTest is Test {
  NaughtCoin public naughtCoinContract;
  NaughtCoinHack public naughtCoinHackContract;
  address tom = address(0x01);
  address gil = address(0x02);
  

  function setUp() public {
    vm.startPrank(tom);
    vm.deal(tom, 5 ether);

    naughtCoinContract = new NaughtCoin(tom);
    naughtCoinHackContract = new NaughtCoinHack(address(naughtCoinContract));
    vm.stopPrank();
  }

  function testTransfer() public {
    assertEq(naughtCoinContract.balanceOf(tom), naughtCoinContract.INITIAL_SUPPLY());
    assertEq(naughtCoinContract.balanceOf(gil), 0);

    vm.startPrank(tom);
    naughtCoinContract.approve(address(naughtCoinHackContract), naughtCoinContract.balanceOf(address(tom)));
    (bool sent) = naughtCoinHackContract.transfer(gil, naughtCoinContract.allowance(tom, address(naughtCoinHackContract)));
    vm.stopPrank();

    assertTrue(sent);
    assertEq(naughtCoinContract.balanceOf(gil), naughtCoinContract.INITIAL_SUPPLY());
    assertEq(naughtCoinContract.balanceOf(tom), 0);
  }
}