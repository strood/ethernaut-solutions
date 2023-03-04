// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GoodSamaritan.sol";
import "../src/GoodSamaritanHack.sol";

contract DoubleEntryPointTest is Test {
  Coin public coinContract;
  Wallet public walletContract;
  GoodSamaritan public goodSamaritanContract;
  GoodSamaritanHack public goodSamaritanHackContract;

  // Tony will be our owner/goodsamaritan
  address tony = address(0x01);

  address attacker = address(0x02);

  function setUp() public {
    // Setup contracts as tony/owner
    vm.startPrank(tony);
    vm.deal(tony, 500 ether);
    vm.deal(attacker, 500 ether);

    // Sets up our Wallet and coin
    goodSamaritanContract = new GoodSamaritan();
    coinContract = goodSamaritanContract.coin();
    walletContract = goodSamaritanContract.wallet();
    vm.stopPrank();

    // Setup hack contract
    vm.startPrank(attacker);
    goodSamaritanHackContract = new GoodSamaritanHack(address(coinContract), address(goodSamaritanContract));
    vm.stopPrank();

  }

  function testBeg() public {

    vm.startPrank(attacker);

    uint256 initialGSWBalance = coinContract.balances(address(walletContract));
    uint256 initialHackContractBalance = coinContract.balances(address(goodSamaritanHackContract));
    assertEq(initialHackContractBalance, 0);
    // No need to expect revert as they are caught and dealt with, thats 
    // why we get xfer
    // vm.expectRevert(abi.encodeWithSignature("NotEnoughBalance()"));
    goodSamaritanHackContract.beg();
    assertEq(coinContract.balances(address(walletContract)), initialHackContractBalance);
    assertEq(coinContract.balances(address(goodSamaritanHackContract)), initialGSWBalance);
    
    // For script we can withdraw here too for getting funds from hack contract to attacker
    
    vm.stopPrank();
  }
}