// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/proxy/Clones.sol";

import {console2} from "forge-std/Test.sol";

contract Caller {
    bytes32 immutable BYTECODE_PROXY_CREATIONCODEHASH =
        keccak256(type(BytecodeProxy).creationCode);
    bytes32 immutable CALLDATA_PROXY_CREATIONCODEHASH =
        keccak256(type(CalldataProxy).creationCode);
    // bytes32 immutable IMMUTABLE_PROXY_CREATIONCODEHASH =
    //     keccak256(type(ImmutableProxy).creationCode);

    bytes32 immutable SALT = keccak256(abi.encode("hello"));
    Implementation tempImpl = Implementation(address(1));
    address tempCred = address(1);

    constructor() {}

    function deployBytecodeProxy(
        Implementation _impl,
        address cred
    ) external returns (address proxy) {
        tempImpl = _impl;
        tempCred = cred;
        proxy = address(new BytecodeProxy{salt: SALT}());
    }

    function deployCalldataProxy() external returns (address) {
        return address(new CalldataProxy{salt: SALT}());
    }

    function deployCloneProxy(Implementation impl) external returns (address) {
        return Clones.cloneDeterministic(address(impl), SALT);
    }

    function deployImmutableProxy(
        Implementation _impl,
        address cred
    ) external returns (address) {
        return address(new ImmutableProxy{salt: SALT}(_impl, cred));
    }

    function callBytecodeProxy() external {
        (bool success, ) = computeBytecodeProxyAddress().call("");
        require(success);
    }

    function callCalldataProxy(
        Implementation impl,
        address cred
    ) external view {
        CalldataProxy(computeCalldataProxyAddress()).forward(impl, cred);
    }

    function callCloneProxy(Implementation impl, address cred) external view {
        Implementation(computeCloneProxyAddress(impl)).foo(cred);
    }

    function callImmutableProxy(Implementation impl, address cred) external {
        (bool success, ) = computeImmutableProxyAddress(impl, cred).call(")");
        require(success);
    }

    function computeBytecodeProxyAddress() public view returns (address) {
        return getAddress(BYTECODE_PROXY_CREATIONCODEHASH, SALT);
    }

    function computeCalldataProxyAddress() public view returns (address) {
        return getAddress(CALLDATA_PROXY_CREATIONCODEHASH, SALT);
    }

    function computeCloneProxyAddress(
        Implementation impl
    ) public view returns (address) {
        return Clones.predictDeterministicAddress(address(impl), SALT);
    }

    function computeImmutableProxyAddress(
        Implementation impl,
        address cred
    ) public view returns (address) {
        bytes memory bytecode = abi.encodePacked(
            type(ImmutableProxy).creationCode,
            abi.encode(impl, cred)
        );
        return getAddress(keccak256(bytecode), SALT);
    }

    function getImplAndCred() external view returns (Implementation, address) {
        return (tempImpl, tempCred);
    }

    function getAddress(
        bytes32 bytecodeHash,
        bytes32 _salt
    ) public view returns (address) {
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, bytecodeHash)
        );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint(hash)));
    }
}

contract BytecodeProxy {
    Implementation private immutable impl;
    address private immutable cred;

    constructor() {
        (impl, cred) = Caller(msg.sender).getImplAndCred();
    }

    fallback() external {
        address _impl = address(impl);
        bytes memory data = abi.encodeWithSelector(
            Implementation.foo.selector,
            cred
        );
        assembly {
            let success := call(gas(), _impl, 0, add(data, 0x20), data, 0, 0)
            returndatacopy(0, 0, returndatasize())
            if iszero(success) {
                revert(0, returndatasize())
            }
            return(0, returndatasize())
        }
    }
}

contract CalldataProxy {
    function forward(Implementation impl, address cred) external view {
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

    fallback() external {
        address _impl = address(impl);
        bytes memory data = abi.encodeWithSelector(
            Implementation.foo.selector,
            cred
        );
        assembly {
            let success := call(gas(), _impl, 0, add(data, 0x20), data, 0, 0)
            returndatacopy(0, 0, returndatasize())
            if iszero(success) {
                revert(0, returndatasize())
            }
            return(0, returndatasize())
        }
    }
}

contract Implementation {
    address immutable cred;

    constructor(address _cred) {
        cred = _cred;
    }

    function foo(address _cred) external view {
        require(cred == _cred);
    }
}
