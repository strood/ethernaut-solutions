
-=-=-=-=-=-=-=NOTES=-=-=-=-=-=-=-

- Super easy to fork a chain to play with:
anvil --fork-url https://goerli.infura.io/v3/${Infura Key}

- Once running, can call contracts on it, simple ones like:
cast call 0x92459e01eC7535d57a5177Ac2259C3E251e0467d "info1()" | xargs cast --abi-decode "a()(string)"

-(info1() is the function, need to decode based on abi, can kinda guess it)
Note: add in --rpc-url GOERELI_RPC_URL to call on live net, or mainnet

- Calling w/ params, need to pass into abi and function, then list them after before pipe: 
cast call $ADDRESS "info2(string)" "hello" | xargs cast --abi-decode "a(string)(string)" "hello"

- Calling a property:
cast call $ADDRESS "infoNum()" | xargs cast --abi-decode "a()(uint8)"

- If no return, dont decode
cast call 0x92459e01eC7535d57a5177Ac2259C3E251e0467d "authenticate(string)" "ethernaut0"


- Send value in transaction with cast send:
cast send --private-key $PRIVATE_KEY $ADDRESS --value 0.0001ether
OR
cast send --from $ADDRES $ADDRESS --value 0.0001ether
OR
- Send to payable function 
cast send --private-key $PRIVATE_KEY $ADDRESS "contribute()" --value 0.0001ether


- Notes: 
-need to add this to test contracts if we want to make them receive money during tests:
 receive() external payable {}

-You can use the view function modifier on an interface in
  order to prevent state modifications.
  The pure modifier also prevents functions from modifying the state. Make sure you read Solidity's documentation and learn its caveats.

-Can send emptyy data of differrent length
  to determine what to do if calling yourself
  0x00 vs 0x0000 can trigger diff response


- DEBUGGER -----

forge run *test contract,* *test function* *calldata* --debug
-- TRY OUT DEBUGGER


- SCRIPTS ----
# To load the variables in the .env file
source .env
# To deploy and verify our contract
forge script script/NFT.s.sol:MyScript --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
OR
to test locally:, after forking goereli
forge script script/Fallback.s.sol:FallbackScript --rpc-url http://localhost:8545 --broadcast -vvvv