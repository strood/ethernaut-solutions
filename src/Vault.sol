// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// https://ethernaut.openzeppelin.com/level/0x3A78EE8462BD2e31133de2B8f1f9CBD973D6eDd6
// Find the password to crack the vault

contract Vault {
  bool public locked;
  bytes32 private password;
  // Since this is just stored in memory we can get it and decode.

  // NOte: COuld pack structs to save on storage space, but thats a diff topic
  // can get storage values and proofs w/ cast
  // cast storage 0x6505a4fE791E7B2402F6c6243Aa0100274778c1D 1 <= for storage in slot 1(0 based)

  // This gives us 0x412076657279207374726f6e67207365637265742070617373776f7264203a29
  // which we decode from hex to decimal to get our password
  // = 'A very strong secret password :)' 
  // Note: must pass in bytes32 pass
  // Just use foundry calls to do this, 
  //cast send --private-key $PRIVATE_KEY 0x6505a4fE791E7B2402F6c6243Aa0100274778c1D "unlock(bytes32)" "0x412076657279207374726f6e67207365637265742070617373776f7264203a29" --rpc-url $GOERLI_RPC_URL

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}