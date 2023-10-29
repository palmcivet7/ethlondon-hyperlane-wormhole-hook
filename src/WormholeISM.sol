// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import {IWormholeRelayer} from "wormhole-solidity-sdk/interfaces/IWormholeRelayer.sol";
import {IWormholeReceiver} from "wormhole-solidity-sdk/interfaces/IWormholeReceiver.sol";
import {IInterchainSecurityModule} from "@hyperlane-xyz/core/contracts/interfaces/IInterchainSecurityModule.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WormholeISM is IWormholeReceiver, Ownable {
    error WormholeISM__InvalidRelayer();
    error WormholeISM__RequestAlreadyProcessed();

    event MessageReceived(bytes message);

    mapping(bytes => bool) public verifiedMessages;
    mapping(bytes32 => bool) public seenDeliveryVaaHashes;

    IWormholeRelayer public wormholeRelayer;

    constructor(address _wormholeRelayer) Ownable(msg.sender) {
        wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
    }

    function receiveWormholeMessages(
        bytes memory payload,
        bytes[] memory, // additionalVaas
        bytes32, // address that called 'sendPayloadToEvm'
        uint16, /* sourceChain */
        bytes32 deliveryHash // this can be stored in a mapping deliveryHash => bool to prevent duplicate deliveries
    ) public payable override {
        if (msg.sender != address(wormholeRelayer)) revert WormholeISM__InvalidRelayer();
        if (seenDeliveryVaaHashes[deliveryHash]) revert WormholeISM__RequestAlreadyProcessed();
        seenDeliveryVaaHashes[deliveryHash] = true;

        bytes memory messageId = payload;
        verifiedMessages[messageId] = true;
        emit MessageReceived(payload);
    }

    function verify(bytes calldata, /* _metadata */ bytes calldata _message) external view returns (bool) {
        return verifiedMessages[_message];
    }

    function moduleType() external pure returns (uint8) {
        return 0;
    }

    ///////// Setter Functions //////////////

    function setWormholeRelayer(address _wormholeRelayer) public onlyOwner {
        wormholeRelayer = IWormholeRelayer(_wormholeRelayer);
    }
}
