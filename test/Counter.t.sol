// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Caller, Implementation} from "../src/Counter.sol";

contract CounterTest is Test {
    Caller public caller;
    Implementation public impl;

    function setUp() public {
        caller = new Caller();
        impl = new Implementation(address(caller));
    }

    function testCalldataProxy() public {
        address proxy = caller.deployCalldataProxy();
        assertEq(proxy, caller.computeCalldataProxyAddress());
        vm.expectCall(address(impl), "");
        caller.callCalldataProxy(impl, address(caller));
    }

    function testImmutableProxy() public {
        address proxy = caller.deployImmutableProxy(impl, address(caller));
        assertEq(
            proxy,
            caller.computeImmutableProxyAddress(impl, address(caller))
        );
        vm.expectCall(address(impl), "");
        caller.callImmutableProxy(impl, address(caller));
    }

    function testBytecodeProxy() public {
        address proxy = caller.deployBytecodeProxy(impl, address(caller));
        assertEq(proxy, caller.computeBytecodeProxyAddress());
        vm.expectCall(address(impl), "");
        caller.callBytecodeProxy();
    }

    function testCloneProxy() public {
        address proxy = caller.deployCloneProxy(impl);
        assertEq(proxy, caller.computeCloneProxyAddress(impl));
        vm.expectCall(address(impl), "");
        caller.callCloneProxy(impl, address(caller));
    }
}
