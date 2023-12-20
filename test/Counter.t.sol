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
        address proxy = caller.deployCalldataProxy();
        caller.callCalldataProxy(impl, address(caller));
        assertEq(proxy, caller.computeCalldataProxyAddress());
    }

    function testImmutableProxy() public {
        address proxy = caller.deployImmutableProxy(impl, address(caller));
        caller.callImmutableProxy(impl, address(caller));
        assertEq(
            proxy,
            caller.computeImmutableProxyAddress(impl, address(caller))
        );
    }

    function testBytecodeProxy() public {
        address proxy = caller.deployBytecodeProxy(impl, address(caller));
        caller.callBytecodeProxy();
        assertEq(proxy, caller.computeBytecodeProxyAddress());
    }

    function testCloneProxy() public {
        address proxy = caller.deployCloneProxy(impl);
        caller.callCloneProxy(impl, address(caller));
        assertEq(proxy, caller.computeCloneProxyAddress(impl));
    }
}
