// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import {Vm} from "lib/forge-std/src/Vm.sol";

library Vyper {
    error Deployment();

    Vm internal constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    function compile(string memory path) internal returns (bytes memory) {
        string[] memory cmd = new string[](2);
        cmd[0] = "vyper";
        cmd[1] = path;
        return vm.ffi(cmd);
    }

    function create(bytes memory initcode) internal returns (address deployment) {
        assembly {
            deployment := create(0, add(initcode, 0x20), mload(initcode))
        }
        if (deployment == address(0)) revert Deployment();
    }
}
