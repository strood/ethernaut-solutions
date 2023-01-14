// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Delegate.sol";
import "../src/DelegateHack.sol";

contract DelegateHackTest is Test {
  Delegate public delegateContract;
  Delegation public delegationContract;
  DelegateHack public delegateHackContract;
  address bob = address(0x1);

  function setUp() public {
    delegateContract = new Delegate(address(this));
    vm.startPrank(bob);
    delegationContract = new Delegation(address(delegateContract));
    vm.stopPrank();
    delegateHackContract = new DelegateHack(address(delegationContract));
  }

  function testSetup() public {
    assertEq(delegateContract.owner(), address(this));
    assertEq(delegationContract.owner(), bob);
  }

  // function testAttack() public {
    // address susan = address(0x2);
    // address tom = address(0x3);
    // console.log("address(this)", bob);
    // assertEq(delegationContract.owner(), bob);
// 
    // vm.startPrank(susan);
    // vm.deal(susan, 10 ether); // Fund susan
    // delegateHackContract.attack();
    // assertEq(delegationContract.owner(), susan);
    // vm.stopPrank();
// 
    // vm.startPrank(tom);
    // vm.deal(tom, 10 ether); // Fund tom
    // delegateHackContract.attack();
    // assertEq(delegationContract.owner(), tom);
    // vm.stopPrank();
  // }
}
