// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "foundry-huff/HuffDeployer.sol";
import "forge-std/Script.sol";
import '../src/DoubleEntryPoint.sol';
import '../src/DetectionBot.sol';

contract DoubleEntryPointHack is Script {
  Forta public fortaContract = Forta(address(0x7117B1b86b29868AFe9Eb40e957Cbb58e7f25262));
  CryptoVault public cryptoVaultContract = CryptoVault(address(0x259aD0Fe4FEebE4f8913B7faD218Dd0C9A155Fc5));
  LegacyToken public legacyTokenContract = LegacyToken(address(0xf10b4E389F7C39b3F9134EbeDDBf475B934232C0));
  DoubleEntryPoint public doubleEntryPointContract = DoubleEntryPoint(address(0x59934558F3A0F4a23840a57Dd58a2897F32CE1A5));
  DetectionBot public detectionBotContract;

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    vm.startBroadcast(attacker);

    // Deploy bot
    detectionBotContract = new DetectionBot(address(fortaContract), address(cryptoVaultContract));
    
    // Add it to Forta
    fortaContract.setDetectionBot(address(detectionBotContract));

    uint256 initialLEGBalance = legacyTokenContract.balanceOf(address(cryptoVaultContract));
    uint256 initialDEPBalance = doubleEntryPointContract.balanceOf(address(cryptoVaultContract));
    uint256 initialAlerts = fortaContract.botRaisedAlerts(0x359bfB5160946a55f03c080c2DC6975C8F970d5C);
    
    // Expected to fail
    // cryptoVaultContract.sweepToken(legacyTokenContract);

    vm.stopBroadcast();
  }
}