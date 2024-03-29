// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Token {
  // No safemath makes this vulnerable to overflow/underflow/
  // send 21(more than 20 tokens) to another account and balance will underflow to 255
  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}