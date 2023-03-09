// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Test contract follwing: https://medium.com/@mweiss.eth/solidity-and-evm-bit-shifting-and-masking-in-assembly-yul-942f4b4ebb6a
// Deployed on Goerli as: 
contract Bitshifter {
  uint128 public C = 4;
  uint104 public D = 6;
  uint16 public E = 8;
  uint8 public F = 1;

  // Read bytes32 content inside slot you pass
  function readBySlot(uint256 slot) external view returns (bytes32 value) {
    // Currently this will return all our vars packed togethter
    // NOTE: Packed top down, so F=1 is last as 0x01
    // 0x0100080000000000000000000000000600000000000000000000000000000004
    assembly {
      value:= sload(slot)
    }
  }

  // TO grab packed vars need to grab from offset, ie E=8
  function getEoffset() external pure returns (uint32 offset) {
    // Returns 29, meaning var is 29 bytes left
    assembly {
      offset := E.offset
    }
  }

  // To grab E we need to shift it to position in last byte
  // This is close but still leaves us with the 0x01 attached to our answer
  // To get rid, we MASK
  function shiftE() external view returns (uint256 masked) {
    assembly {
      let slot := sload(E.slot)
      // We get bytes from offset, shr shifts bits, so multiply by 8
      // Returns 0x0000000000000000000000000000000000000000000000000000000000010008
      let e := shr(mul(E.offset, 8), slot)
      // This is close but still leaves us with the 0x01 attached to our answer
      // To get rid, we MASK
      //rules:
      // 
      //f = 1111
      //ff = 11111111
      //V stands for value
      // V and 00 = 00
      // V and FF = V
      // V or  00 = V
      masked := and(0xffff, e) // Retuns 8

    }
  }


  // Now to update a storage slot
  function writeE(uint16 newE) external returns (bytes32 value, bytes32 clearedE, bytes32 newV, bytes32 shifted) {
    assembly {
      // newE 0x00...00a = 10
      // Load slot
      value := sload(E.slot)
      // We want to delete e value w/ mask. Keep everythign w/ f
      clearedE := and(0xff0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, value)
      // We take the new E, 10=a in hex, shift it to the offset
      //0x00000a0000000000000000000000000000000000000000000000000000000000
      shifted := shl(mul(E.offset, 8), newE)

      // now take our clearedE and shifted and combine them as they now line up
      newV := or(shifted, clearedE)
      //newV  0x01000a0000000000000000000000000600000000000000000000000000000004
      // now store it back in the slot
      sstore(E.slot, newV)
    }
  }

}