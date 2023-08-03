// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.20;

import "lib/forge-std/src/Script.sol";
import "src/util/Deployer.sol";

function toIBytes(address addr) pure returns (IBytes) {
    return IBytes(addr);
}

interface IBytes {
    function memdump() external pure returns (uint256);
}


contract DebugBytesScript is Script {
    using Vyper for bytes;
    using { toIBytes } for address;

    function run() public {
        Vyper
            .compile("src/memory/Bytes.vy")
            .create()
            .toIBytes()
            .memdump();
    }
}
