// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';

contract Fallback {

  using SafeMath for uint256;
  mapping(address => uint) public contributions;
  address payable public owner;

  constructor() public {
    owner = payable(address(msg.sender));
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = payable(address(msg.sender));
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    // NOTE: Because bumped compiler to 0.8.0 from 0.6.0
    // had to change this to call from transfer so 
    // transferring all balance would not fail b/c no gas
    address(owner).call{value: address(this).balance}("");
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = payable(address(msg.sender));
  }
}