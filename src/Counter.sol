// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";

contract Caller {
    CalldataProxy public calldataProxy;
    ImmutableProxy public immutableProxy;
    BytecodeProxy public bytecodeProxy;
    Implementation public cloneProxy;

    bytes32 salt = keccak256(abi.encode("hello"));
    Implementation tempImpl;
    address tempCred;

    function deployCalldataProxy() external {
        calldataProxy = new CalldataProxy{salt: salt}();
    }

    function deployImmutableProxy(Implementation _impl) external {
        immutableProxy = new ImmutableProxy{salt: salt}(_impl, address(this));
    }

    function deployBytecodeProxy(Implementation _impl) external {
        tempImpl = _impl;
        tempCred = address(this);
        bytecodeProxy = new BytecodeProxy{salt: salt}();
    }

    function deployCloneProxy(Implementation impl) external {
        cloneProxy = Implementation(
            Clones.cloneDeterministic(address(impl), salt)
        );
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

    function callCloneProxy() external {
        cloneProxy.foo(address(this));
    }

    function computeCalldataProxyAddress() external view returns (address) {
        return getAddress(type(CalldataProxy).creationCode, salt);
    }

    function computeImmutableProxyAddress(
        Implementation impl,
        address cred
    ) external view returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(ImmutableProxy).creationCode,
            abi.encode(impl, cred)
        );
        return getAddress(bytecode, salt);
    }

    function computeBytecodeProxyAddress() external view returns (address) {
        return getAddress(type(BytecodeProxy).creationCode, salt);
    }

    function computeCloneProxyAddress(
        Implementation impl
    ) external view returns (address) {
        return Clones.predictDeterministicAddress(address(impl), salt);
    }

    function getImplAndCred() external view returns (Implementation, address) {
        return (tempImpl, tempCred);
    }

    // 2. Compute the address of the contract to be deployed
    // NOTE: _salt is a random number used to create an address
    function getAddress(
        bytes memory bytecode,
        bytes32 _salt
    ) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(
                bytes1(0xff),
                address(this),
                _salt,
                keccak256(bytecode)
            )
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }
}

contract CalldataProxy {
    function forward(Implementation impl, address cred) external {
        impl.foo(cred);
    }
}

contract ImmutableProxy {
    Implementation private immutable impl;
    address private immutable cred;

    constructor(Implementation _impl, address _cred) {
        impl = _impl;
        cred = _cred;
    }

    function forward() external {
        impl.foo(cred);
    }
}

contract BytecodeProxy {
    Implementation private immutable impl;
    address private immutable cred;

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
