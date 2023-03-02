// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";
import '../src/MagicNum.sol';
interface Solver {
  function whatIsTheMeaningOfLife() view external returns (bytes32);
}

contract MagicNumDeploy is Script {
  MagicNum public magicNumContract = MagicNum(payable(address(0x3615914d2A2Eee1271dEDef21997c0ee47E4239D)));

  function run() public returns (Solver solver) {
    // deploy and set our solver
    solver = Solver(HuffDeployer.deploy("Solver"));
    magicNumContract.setSolver(address(solver));
  }
}
