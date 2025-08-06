// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/RussianRuble.sol";

contract RussianRubleTest is Test {
    RussianRuble public rub;
    address public owner;
    address public user;
    uint256 public constant INITIAL_MINT = 1000 * 10**18;
    uint256 public constant TRANSFER_AMOUNT = 100 * 10**18;

    function setUp() public {
        owner = address(this);
        user = address(0x123);
        
        // Deploy the contract
        rub = new RussianRuble();
        
        // Mint initial supply to the owner
        rub.mint(owner, INITIAL_MINT);
    }

    function testInitialSetup() public {
        assertEq(rub.name(), "Russian Ruble");
        assertEq(rub.symbol(), "RUB");
        assertEq(rub.decimals(), 18);
        assertEq(rub.totalSupply(), INITIAL_MINT);
        assertEq(rub.balanceOf(owner), INITIAL_MINT);
    }

    function testTransfer() public {
        rub.transfer(user, TRANSFER_AMOUNT);
        assertEq(rub.balanceOf(user), TRANSFER_AMOUNT);
        assertEq(rub.balanceOf(owner), INITIAL_MINT - TRANSFER_AMOUNT);
    }

    function testMint() public {
        uint256 beforeMint = rub.totalSupply();
        rub.mint(user, TRANSFER_AMOUNT);
        assertEq(rub.totalSupply(), beforeMint + TRANSFER_AMOUNT);
        assertEq(rub.balanceOf(user), TRANSFER_AMOUNT);
    }

    function testBurn() public {
        uint256 beforeBurn = rub.totalSupply();
        rub.burn(TRANSFER_AMOUNT);
        assertEq(rub.totalSupply(), beforeBurn - TRANSFER_AMOUNT);
        assertEq(rub.balanceOf(owner), INITIAL_MINT - TRANSFER_AMOUNT);
    }

    function testPause() public {
        rub.pause();
        assertTrue(rub.paused());
        
        // Transfer should fail when paused
        vm.expectRevert();
        rub.transfer(user, TRANSFER_AMOUNT);
        
        // Unpause and try transfer again
        rub.unpause();
        assertFalse(rub.paused());
        rub.transfer(user, TRANSFER_AMOUNT);
        assertEq(rub.balanceOf(user), TRANSFER_AMOUNT);
    }

    function testOwnership() public {
        address newOwner = address(0x456);
        
        // Transfer ownership
        rub.transferOwnership(newOwner);
        assertEq(rub.owner(), newOwner);
        
        // Functions should now fail when called by old owner
        vm.expectRevert();
        rub.mint(user, TRANSFER_AMOUNT);
        
        // But should work when called by new owner
        vm.prank(newOwner);
        rub.mint(user, TRANSFER_AMOUNT);
        assertEq(rub.balanceOf(user), TRANSFER_AMOUNT);
    }
} 