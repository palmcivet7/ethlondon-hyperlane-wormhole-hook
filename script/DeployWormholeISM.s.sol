// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import {Script} from "forge-std/Script.sol";
import {WormholeISM} from "../src/WormholeISM.sol";

contract DeployWormholeISM is Script {
    address wormholeRelayer = 0xA3cF45939bD6260bcFe3D66bc73d60f19e49a8BB; // fuji relayer https://docs.wormhole.com/wormhole/blockchain-environments/evm#avalanche

    function run() external returns (WormholeISM) {
        vm.startBroadcast();
        WormholeISM wormIsm = new WormholeISM(wormholeRelayer);
        vm.stopBroadcast();
        return (wormIsm);
    }
}
