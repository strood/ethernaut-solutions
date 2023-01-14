// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/CoinFlip.sol";
import "../src/CoinFlipHack.sol";

contract CoinFlipHackTest is Test {
  CoinFlip public coinFlipContract;
  CoinFlipHack public coinFlipHackContract;

  function setUp() public {
    coinFlipContract = new CoinFlip();
    coinFlipHackContract = new CoinFlipHack(address(coinFlipContract));
  }

  function testDoubleWin() public {
    coinFlipHackContract.makeGuess();
    assertEq(coinFlipContract.consecutiveWins(), 1);
    vm.roll(block.number + 1);
    coinFlipHackContract.makeGuess();
    assertEq(coinFlipContract.consecutiveWins(), 2);
  }

  function testTenWin() public {
    uint n = 1;
    while(coinFlipContract.consecutiveWins() < 10) {
      coinFlipHackContract.makeGuess();
      assertEq(coinFlipContract.consecutiveWins(), n);
      vm.roll(block.number + 1);
      n++;
    }

    assertEq(coinFlipContract.consecutiveWins(), 10);
  }
}