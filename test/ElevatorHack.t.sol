// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/Elevator.sol";
import "../src/ElevatorHack.sol";

contract ElevatorHackTest is Test {
  Elevator public elevatorContract;
  ElevatorHack public elevatorHackContract;
  address jon = address(0x1);
  address tim = address(0x2);

  function setUp() public {
    vm.startPrank(jon);
    vm.deal(jon, 2 ether);

    elevatorContract = new Elevator();
    elevatorHackContract = new ElevatorHack(address(elevatorContract));
    vm.stopPrank();
  }

  function testAttack() public {

    assertTrue(elevatorContract.top() == false);

    elevatorHackContract.attack();

    assertTrue(elevatorContract.top() == true);
  }

}
