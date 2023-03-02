
// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/MagicNum.sol";

contract MagicNumTest is Test {
  MagicNum public magicNumContract = MagicNum(address(0x3615914d2A2Eee1271dEDef21997c0ee47E4239D));
  // Setup our solver contract
  function setUp() public {
  }

  function testGetMeaning() public {
    address solver;
    assembly {
      let ptr := mload(0x40)
      mstore(ptr, shl(0x68, 0x69602A60005260206000F3600052600A6016F3))
      solver := create(0, ptr, 0x13)
    }
    // assertEq(solver.whatIsTheMeaningOfLife(), 0x000000000000000000000000000000000000000000000000000000000000002a);
    // magicNumContract.setSolver(solver);
  }
}

interface Solver {
  function whatIsTheMeaningOfLife() view external returns (bytes32);
}