// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Telephone.sol";
import "../src/TelephoneHack.sol";

contract TelephoneHackTest is Test {
  Telephone public telephoneContract;
  TelephoneHack public telephoneHackContract;

  function setUp() public {
    telephoneContract = new Telephone();
    telephoneHackContract = new TelephoneHack(address(telephoneContract));
  }


  function testTele() public {
    telephoneHackContract.callTelephone(address(this));
    assertEq(telephoneContract.owner(), address(this));
  }
}