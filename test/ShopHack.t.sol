// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Shop.sol";
import "../src/ShopHack.sol";

contract ShopHackTest is Test {
  Shop public shopContract;
  ShopHack public shopHackContract;

  address attackOwner = address(0x1);
  address shopOwner = address(0x2);

  function setUp() public {
    vm.startPrank(shopOwner);

    vm.deal(shopOwner, 5 ether);

    shopContract = new Shop(); 

    vm.stopPrank();

    vm.startPrank(attackOwner);
    vm.deal(attackOwner, 5 ether);
    shopHackContract = new ShopHack(address(shopContract));

    vm.stopPrank();

  }

  function testAttack() public {
    vm.startPrank(attackOwner);

    assertTrue(shopContract.price() == 100);
    assertTrue(shopHackContract.targetContract() == shopContract);

    shopHackContract.attack();
    emit log_uint(shopContract.price());
    assertTrue(shopContract.isSold());
    assertTrue(shopHackContract.price() == 0);
    assertTrue(shopContract.price() == 0);
    vm.stopPrank();
  }

}