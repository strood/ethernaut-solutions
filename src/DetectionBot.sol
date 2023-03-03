// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./DoubleEntryPoint.sol";
// We want to make sure the transferred token does not equal 
// our underlying

struct TransactionParams {
    address to;
    uint256 value;
    address origSender;
}
contract DetectionBot is IDetectionBot {
  Forta public fortaContract;
  CryptoVault public vaultContract;

  constructor(address forta, address vault) {
    fortaContract = Forta(forta);
    vaultContract = CryptoVault(vault);
  }

  function handleTransaction(address user, bytes calldata msgData) override external {
    // If anomoly detected, raise alert on the Forta contract
    // My msgData is going to be TransactionParams
    // Make sure orig sender is not vault, we dont want to send away our keys
    // Decode params and check if equal slice off function selector w [4:]
    TransactionParams memory decoded = abi.decode(msgData[4:], (TransactionParams));
    if(decoded.origSender == address(vaultContract)) {
      fortaContract.raiseAlert(user);
    }
  }
}