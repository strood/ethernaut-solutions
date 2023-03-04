// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatekeeperTwo {

  address public entrant;

  // Send from contract I call
  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }
  // Do it in constructor of contract
  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  // Doing a XOR operation on the uint64 hex values of the msg sender address and the gate key.
  // we want to apply the values in gate key to push our value as a sender to 0xffffffffffffffff = type(uint64).max
  // can do this and find value of uint64(bytes8(0xbceabdb61dd27fbe)) gets us a XOR
  // value of 0xffffffffffffffff with uint64(bytes8(keccak256(abi.encodePacked(0x359bfB5160946a55f03c080c2DC6975C8F970d5C))))
  // Just used chisel for this and mess with the values, or, we find that if you take the XOR operation of:
  // uint64(bytes8(keccak256(abi.encodePacked(0x359bfB5160946a55f03c080c2DC6975C8F970d5C)))) ^  0xffffffffffffffff 
  // We get our answer of 0xbceabdb61dd27fbe, we can set up our call this way to calculate on fly instead of pre-set for our 
  // one attacker contract
  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
  }
}