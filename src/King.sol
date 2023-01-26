// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


// Can complete from command line w/ foundry, just send the contract enough ether
//cast send --from 0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266 0x2051935bBa1ca07084D11e8Fb9d5fcC8d37e7511 --value 1.1ether
// no data so will go to receive, we are now king,
// but need to do this with a contract so we retain kingship
contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}