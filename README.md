-=-=-=-=-=-=-=NOTES=-=-=-=-=-=-=-

- Super easy to fork a chain to play with:
anvil --fork-url https://goerli.infura.io/v3/${Infura Key}

- Once running, can call contracts on it, simple ones like:
cast call 0x92459e01eC7535d57a5177Ac2259C3E251e0467d "info1()" | xargs cast --abi-decode "a()(string)"

-(info1() is the function, need to decode based on abi, can kinda guess it)

- Calling w/ params, need to pass into abi and function, then list them after before pipe: 
cast call $ADDRESS "info2(string)" "hello" | xargs cast --abi-decode "a(string)(string)"

- Calling a property:
cast call $ADDRESS "infoNum()" | xargs cast --abi-decode "a()(uint8)"

- If no return, dont decode
cast call 0x92459e01eC7535d57a5177Ac2259C3E251e0467d "authenticate(string)" "ethernaut0"


- Send value in transaction with cast send:
cast send --private-key $PRIVATE-KEY $ADDRESS --value 0.0001ether
OR
cast send --from $ADDRES $ADDRESS --value 0.0001ether
OR
- Send to payable function 
cast send --private-key $PRIVATE_KEY $ADDRESS "contribute()" --value 0.0001ether