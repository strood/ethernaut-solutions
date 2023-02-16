// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Preservation.sol";
import "../src/PreservationHack.sol";

contract PreservationHackScript is Script {
  SpecialLibraryContract public specialLibraryContract;
  Preservation public preservationContract = Preservation(0xeC26b6e2DcEF7c9d6434737312e0fD1eDE8BC6eb);

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(attacker);

    specialLibraryContract = new SpecialLibraryContract();

  }
}
