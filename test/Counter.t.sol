// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function test_SetNumberAsOwner() public {
        assertEq(counter.owner(), address(this));
        counter.setNumber(100);
        assertEq(counter.number(), 100);
    }

    function test_SetNumberAsNonOwner() public {
        vm.prank(address(0x123)); // Switch to a non-owner address
        vm.expectRevert();
        counter.setNumber(100);
    }
}
