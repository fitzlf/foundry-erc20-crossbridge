// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/RussianRuble.sol";

contract RussianRubleScript is Script {
    function run() public {
        // Get the private key from the environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the Russian Ruble contract
        RussianRuble rub = new RussianRuble();
        
        // Mint initial supply if needed
        // Example: Mint 1 million tokens to the deployer
        rub.mint(vm.addr(deployerPrivateKey), 1_000_000 * 10**18);
        
        // End broadcasting transactions
        vm.stopBroadcast();
        
        // Log the deployed contract address
        console.log("Russian Ruble deployed at:", address(rub));
    }
} 