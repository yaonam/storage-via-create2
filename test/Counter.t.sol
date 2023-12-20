// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Caller, Implementation} from "../src/Counter.sol";

contract CounterTest is Test {
    Caller public caller;
    Implementation public impl;

    function setUp() public {
        caller = new Caller();
        impl = new Implementation();
    }

    // function test_Increment() public {
    //     counter.increment();
    //     assertEq(counter.number(), 1);
    // }

    // function testFuzz_SetNumber(uint256 x) public {
    //     counter.setNumber(x);
    //     assertEq(counter.number(), x);
    // }

    function testCalldataProxy() public {
        caller.deployCalldataProxy();
        caller.callCalldataProxy(impl, address(caller));
    }

    function testImmutableProxy() public {
        caller.deployImmutableProxy(impl);
        caller.callImmutableProxy();
    }

    function testBytecodeProxy() public {
        caller.deployBytecodeProxy(impl);
        caller.callBytecodeProxy();
    }
}
