pragma solidity 0.8.20;

import "src/util/Deployer.sol";
import "lib/forge-std/src/Script.sol";

using Vyper for bytes;
using Vyper for Vm;

contract S is Script {
    function run() public {
        Vyper.compile("src/memory/Overwrite.vy").create().call(
            abi.encodeWithSignature("overwrite(bool)", (true))
        );
    }
}

