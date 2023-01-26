// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Privacy {

  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp);
  bytes32[3] private data;

  // We can inspect storage slots w/ cast storage *contract* *slot#*
  // IN this case slot 3-5 holds our data object values
  // We store as 32 bit, but we check for 16 bit of the [2] slot,
  // So we need to grab the first 16/32 in that slot and submit to unlock
  // Looks liek: 
  //cast send --private-key $PRIVATE_KEY
  // 0x8fd58d16D79bFF21E090fCc30B49DdD1A13C6715 "unlock(bytes16)"
  // 725e45d4e563743e47058d22a8a85e08 --rpc-url $GOERLI_RPC_URL

  // Gets us the unlock, how to do via contract?
  // can I look at another contracts storage slots from in a contract?

  constructor(bytes32[3] memory _data) {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
}