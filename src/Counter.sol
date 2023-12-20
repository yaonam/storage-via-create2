// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Caller {
    CalldataProxy calldataProxy;
    StorageProxy storageProxy;
    BytecodeProxy bytecodeProxy;

    uint nonce;
    Implementation public tempImpl;

    function deployCalldataProxy() external {
        calldataProxy = new CalldataProxy{
            salt: keccak256(abi.encode(nonce++))
        }();
    }

    function deployStorageProxy(Implementation _impl) external {
        storageProxy = new StorageProxy{salt: keccak256(abi.encode(nonce))}(
            _impl,
            address(this)
        );
    }

    function deployBytecodeProxy(Implementation _impl) external {
        tempImpl = _impl;
        bytecodeProxy = new BytecodeProxy{salt: keccak256(abi.encode(nonce))}();
    }

    function callCalldataProxy(Implementation impl, address cred) external {
        calldataProxy.forward(impl, cred);
    }

    function callStorageProxy() external {
        storageProxy.forward();
    }

    function callBytecodeProxy() external {
        bytecodeProxy.forward();
    }

    function getImplAndCred() external view returns (Implementation, address) {
        return (tempImpl, address(this));
    }
}

contract CalldataProxy {
    function forward(Implementation impl, address cred) external {
        impl.foo(cred);
    }
}

contract StorageProxy {
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
