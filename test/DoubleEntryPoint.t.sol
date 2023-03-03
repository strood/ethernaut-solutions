// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/DoubleEntryPoint.sol";
import "../src/DetectionBot.sol";

contract DoubleEntryPointTest is Test {
  Forta public fortaContract;
  CryptoVault public cryptoVaultContract;
  LegacyToken public legacyTokenContract;
  DoubleEntryPoint public doubleEntryPointContract;
  DetectionBot public detectionBotContract;

  address tony = address(0x01);
  address frank = address(0x02);

  function setUp() public {
    // Setup contracts as tony/owner
    vm.startPrank(tony);
    vm.deal(tony, 500 ether);
    vm.deal(frank, 500 ether);

    fortaContract = new Forta();
    cryptoVaultContract = new CryptoVault(tony);
    legacyTokenContract = new LegacyToken();
    legacyTokenContract.mint(address(cryptoVaultContract), 100 ether);
    emit log_uint(legacyTokenContract.balanceOf(address(cryptoVaultContract)));
    doubleEntryPointContract = new DoubleEntryPoint(address(legacyTokenContract), address(cryptoVaultContract), address(fortaContract), frank);
    cryptoVaultContract.setUnderlying(address(doubleEntryPointContract));
    legacyTokenContract.delegateToNewContract(doubleEntryPointContract);
    vm.stopPrank();

    vm.startPrank(frank);
    detectionBotContract = new DetectionBot(address(fortaContract), address(cryptoVaultContract));
    fortaContract.setDetectionBot(address(detectionBotContract));
    vm.stopPrank();

  }

  function testSweep() public {

    vm.startPrank(frank);

    uint256 initialLEGBalance = legacyTokenContract.balanceOf(address(cryptoVaultContract));
    uint256 initialDEPBalance = doubleEntryPointContract.balanceOf(address(cryptoVaultContract));
    uint256 initialAlerts = fortaContract.botRaisedAlerts(frank);
    vm.expectRevert();
    cryptoVaultContract.sweepToken(legacyTokenContract);
    assertEq(legacyTokenContract.balanceOf(frank), 0);
    assertEq(doubleEntryPointContract.balanceOf(frank), 0);
    assertEq(legacyTokenContract.balanceOf(address(cryptoVaultContract)), initialLEGBalance);
    assertEq(doubleEntryPointContract.balanceOf(address(cryptoVaultContract)), initialDEPBalance);
    // assertEq(fortaContract.botRaisedAlerts(frank), initialAlerts + 1);

    vm.stopPrank();
  }
}