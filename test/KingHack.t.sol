// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/KingHack.sol";
import "../src/King.sol";

contract KingHackTest is Test {
  KingHack public kingHackContract;
  King public kingContract;
  function setUp() public {
    address jon = address(0x1);
    address tim = address(0x2);

    vm.startPrank(tim);
    vm.deal(tim, 5 ether);
    kingContract = new King{value: 1 ether}();
    vm.stopPrank();

    vm.startPrank(jon);
    vm.deal(jon, 5 ether);
    kingHackContract = new KingHack{value: 2 ether}(address(kingContract));
    vm.stopPrank();

  }

  function testAttack() public {
    emit log_uint(address(kingHackContract).balance);
    emit log_uint(address(kingContract).balance);
    emit log_address(kingHackContract.owner());
    emit log_address(kingContract.owner());
    emit log_uint(kingContract.prize());

    emit log_address(kingContract._king()); // King before
    kingHackContract.becomeKing{value: kingContract.prize() + 0.000000000000000001 ether}();
    emit log_address(kingContract._king()); // King after
    assertTrue(kingContract._king() == address(kingHackContract));

  }
}