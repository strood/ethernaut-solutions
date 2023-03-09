// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import '../src/Bitshift.sol';

contract BitshiftDeploy is Script {
    Bitshifter public bitshiftContract;
    function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    vm.startBroadcast(attacker);

    // Deploy bitshift
    bitshiftContract = new Bitshifter();
    

    vm.stopBroadcast();
  }

}
