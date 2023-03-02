
// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract MagicNumTest is Test {
  Solver public solver;

  // Setup our solver contract
  function setUp() public {
    solver = Solver(HuffDeployer.deploy("Solver"));
  }

  function testGetMeaning() public {
    solver.whatIsTheMeaningOfLife();
    assertEq(solver.whatIsTheMeaningOfLife(), 0x000000000000000000000000000000000000000000000000000000000000002a);
  }
}

interface Solver {
  function whatIsTheMeaningOfLife() view external returns (bytes32);
}