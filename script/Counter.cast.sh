#! /bin/bash

cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "increment()" \
  --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 \
  --rpc-url http://localhost:8545

cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "number()(uint256)"


cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "setNumber(uint256)" 999 \
  --private-key 0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d \
  --rpc-url http://localhost:8545