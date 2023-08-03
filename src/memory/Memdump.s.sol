// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "lib/forge-std/src/Vm.sol";
import "lib/forge-std/src/Script.sol";
import "src/util/Deployer.sol";

contract Memdump is Script {
    using Vyper for bytes;
    uint256 internal constant wordsize = 0x20;
    uint256 internal constant padding = 0x1f;
    uint256 internal constant mask = 0xff;
    uint256 internal constant opreturn = 0xf3;

    uint256 internal constant memdump_address = 0x69;
    uint256 internal constant memdump_selector = 0x730d5ada00000000000000000000000000000000000000000000000000000000;

    // left-aligned instructions:
    //
    // msize    0x59
    // push0    0x5f
    // return   0xf3
    uint256 internal constant memdump = 0x595ff30000000000000000000000000000000000000000000000000000000000;

    function run() public {
        string[] memory cmd = new string[](4);
        cmd[0] = "vyper";
        cmd[1] = "-f";
        cmd[2] = "bytecode_runtime";
        cmd[3] = "src/memory/Memdump.vy";
        bytes memory runtime = vm.ffi(cmd);

        _injectMemdump(runtime);

        vm.etch(address(uint160(memdump_address)), runtime);

        bytes memory vyperMemory = new bytes(0);

        assembly {
            mstore(0x00, memdump_selector)
            if iszero(staticcall(gas(), memdump_address, 0x00, 0x04, 0x00, 0x00)) {
                revert(0x00, 0x00)
            }

            vyperMemory := mload(0x40)
            mstore(vyperMemory, returndatasize())
            returndatacopy(add(vyperMemory, wordsize), 0x00, returndatasize())
            mstore(0x40, add(vyperMemory, returndatasize()))
        }

        console.logBytes(vyperMemory);
    }

    // mutates the `runtime` in place, injects the `memdump` into the bytecode just before `return`
    function _injectMemdump(bytes memory runtime) internal pure {
        assembly {
            let return_index
            let runtime_len := mload(runtime)

            for { let i } lt(i, runtime_len) { i := add(i, 1) } {
                if eq(and(mload(add(runtime, add(wordsize, i))), mask), opreturn) {
                    return_index := i
                    break
                }
            }

            if iszero(return_index) {
                revert(0x00, 0x00)
            }

            mstore(add(add(runtime, add(padding, wordsize)), return_index), memdump)
        }
    }
}
