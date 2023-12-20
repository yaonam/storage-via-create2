// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Caller {
    CalldataProxy calldataProxy;
    ImmutableProxy immutableProxy;
    BytecodeProxy bytecodeProxy;

    uint nonce;
    Implementation tempImpl;
    address tempCred;

    function deployCalldataProxy() external {
        calldataProxy = new CalldataProxy{
            salt: keccak256(abi.encode(nonce++))
        }();
    }

    function deployImmutableProxy(Implementation _impl) external {
        immutableProxy = new ImmutableProxy{salt: keccak256(abi.encode(nonce))}(
            _impl,
            address(this)
        );
    }

    function deployBytecodeProxy(Implementation _impl) external {
        tempImpl = _impl;
        tempCred = address(this);
        bytecodeProxy = new BytecodeProxy{salt: keccak256(abi.encode(nonce))}();
    }

    function callCalldataProxy(Implementation impl, address cred) external {
        calldataProxy.forward(impl, cred);
    }

    function callImmutableProxy() external {
        immutableProxy.forward();
    }

    function callBytecodeProxy() external {
        bytecodeProxy.forward();
    }

    function getImplAndCred() external view returns (Implementation, address) {
        return (tempImpl, tempCred);
    }
}

contract CalldataProxy {
    function forward(Implementation impl, address cred) external {
        impl.foo(cred);
    }
}

contract ImmutableProxy {
    Implementation public immutable impl;
    address public immutable cred;

    constructor(Implementation _impl, address _cred) {
        impl = _impl;
        cred = _cred;
    }

    function forward() external {
        impl.foo(cred);
    }
}

contract BytecodeProxy {
    Implementation public immutable impl;
    address public immutable cred;

    constructor() {
        (impl, cred) = Caller(msg.sender).getImplAndCred();
    }

    function forward() external {
        impl.foo(cred);
    }
}

contract Implementation {
    function foo(address cred) external {}
}
