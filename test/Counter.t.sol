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

    function testCalldataProxy() public {
        caller.deployCalldataProxy();
        caller.callCalldataProxy(impl, address(caller));
        assertEq(
            address(caller.calldataProxy()),
            caller.computeCalldataProxyAddress()
        );
    }

    function testImmutableProxy() public {
        caller.deployImmutableProxy(impl);
        caller.callImmutableProxy();
        assertEq(
            address(caller.immutableProxy()),
            caller.computeImmutableProxyAddress(impl, address(caller))
        );
    }

    function testBytecodeProxy() public {
        caller.deployBytecodeProxy(impl);
        caller.callBytecodeProxy();
        assertEq(
            address(caller.bytecodeProxy()),
            caller.computeBytecodeProxyAddress()
        );
    }

    function testCloneProxy() public {
        caller.deployCloneProxy(impl);
        caller.callCloneProxy();
        assertEq(
            address(caller.cloneProxy()),
            caller.computeCloneProxyAddress(impl)
        );
    }
}
