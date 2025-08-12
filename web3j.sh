#! /bin/bash

# forge build --silent && jq -r '.bytecode.object' ./out/Counter.sol/Counter.json > Counter.bin

jq -r '.abi' ./out/Counter.sol/Counter.json > ./out/Counter.json
web3j generate solidity  -a ./out/Counter.json -o ./out/java -p com.abc

jq -r '.abi' ./out/RussianRuble.sol/RussianRuble.json > ./out/RussianRuble.json
web3j generate solidity  -a ./out/RussianRuble.json -o ./out/java -p com.abc