// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";
import '../src/MagicNum.sol';
interface Solver {
  function whatIsTheMeaningOfLife() view external returns (bytes32);
}

contract MagicNumDeploy2 is Script {
  MagicNum public magicNumContract = MagicNum(payable(address(0x3615914d2A2Eee1271dEDef21997c0ee47E4239D)));

  function run() public {
        uint256 attacker = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(attacker);
    // deploy and set our solver
    address solver;
    assembly {
      let ptr := mload(0x40)
      mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3))
      solver := create(0, ptr, 0x13)
    }
    magicNumContract.setSolver(solver);
    assert(
        Solver(solver).whatIsTheMeaningOfLife() ==
        0x000000000000000000000000000000000000000000000000000000000000002a
    );
        assert(
        magicNumContract.solver() ==
        solver
    );

    vm.stopBroadcast();
  }
}
