// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Denial.sol";
import "../src/DenialHack.sol";

contract DenialHackTest is Test {
  Denial public denialContract;
  DenialHack public denialHackContract;

  address denialOwner = address(0xA9E);
  address attackOwner = address(0x1);
  uint256 originalValue;
  uint256 originalPayout;

  function setUp() public {
    vm.startPrank(attackOwner);
    vm.deal(attackOwner, 5 ether);

    denialContract = new Denial(); // Owner default to 0xA9E
    denialHackContract = new DenialHack();

    // Seed w/ value to extract 1% of
    (bool result,) = address(payable(denialContract)).call{value: 2 ether}("");
    vm.stopPrank();
  }

  function testAttack() public {
    vm.startPrank(denialOwner);

    assertTrue(denialContract.owner() == denialOwner);

    denialHackContract.setTarget(address(denialContract));
    assertTrue(denialContract.partner() == address(denialHackContract));

    denialContract.withdraw();
    emit log_uint(denialContract.contractBalance());
    emit log_uint(address(denialHackContract).balance);
    emit log_uint(address(denialOwner).balance);

    vm.stopPrank();
  }

}