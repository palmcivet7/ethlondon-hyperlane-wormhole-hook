// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import {Script} from "forge-std/Script.sol";
import {WormholeHook} from "../src/WormholeHook.sol";
import {IWormholeRelayer} from "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";

contract DeployWormholeHook is Script {
    IWormholeRelayer relayer = IWormholeRelayer(0x28D8F1Be96f97C1387e94A53e00eCcFb4E75175a);
    address ism = 0xd76c8F9D77788D12bb93c70E89D52544fa4c4e91; // deploy ISM first and use address here
    uint16 targetChain = 6; // fuji target chain id

    function run() external returns (WormholeHook) {
        vm.startBroadcast();
        WormholeHook wormHook = new WormholeHook(relayer, ism, targetChain);
        vm.stopBroadcast();
        return (wormHook);
    }
}
